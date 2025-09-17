POSTS_MD := $(shell yq eval '.posts[]' posts.yaml)

POSTS_XML = $(POSTS_MD:_posts%markdown=_build%xml)

_SEMI := ;
_EMPTY := 
_SPACE := $(_EMPTY) $(_EMPTY)

_POSTS_INDEX = $(POSTS_MD:_posts%markdown=../_build%xml)
POSTS_INDEX = $(subst $(_SPACE),$(_SEMI),$(_POSTS_INDEX))

POSTS_HTML = $(POSTS_MD:_posts%markdown=posts%html)

COMRAK_VERSION := 0.41.1
SAXON_VERSION := 9.1.0.8J
BLOG_URL := https://silverjam.github.io

.PHONY: all
all: check-comrak-version check-saxon-version html index.html about.html tags.html atom.xml sitemap.xml

.PHONY: install-comrak
install-comrak:
	@if ! command -v comrak >/dev/null 2>&1 || ! comrak --version | grep -q "$(COMRAK_VERSION)"; then \
		echo "Installing comrak version $(COMRAK_VERSION)..."; \
		cargo install comrak --force --version "$(COMRAK_VERSION)"; \
	else \
		echo "comrak version $(COMRAK_VERSION) is already installed."; \
	fi

.PHONY: install-saxonb
install-saxonb:
	sudo apt-get install -y libsaxonb-java default-jre

.PHONY: install-yq
install-yq:
	@if ! command -v yq >/dev/null 2>&1; then \
		echo "Installing yq..."; \
		sudo curl -sL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64; \
		sudo chmod +x /usr/local/bin/yq; \
	else \
		echo "yq is already installed."; \
	fi

.PHONY: install-deps
install-deps: install-comrak install-saxonb install-yq

.PHONY: check-comrak-version
check-comrak-version:
	@comrak --version | grep "$(COMRAK_VERSION)" > /dev/null || (echo "Wrong comrak version. Expected $(COMRAK_VERSION)" && exit 1)

.PHONY: check-saxon-version
check-saxon-version:
	@saxonb-xslt -? 2>&1 | grep "Saxon $(SAXON_VERSION)" > /dev/null || (echo "Wrong saxonb version. Expected $(SAXON_VERSION)" && exit 1)

_build/%.xml: _posts/%.markdown
	comrak --front-matter-delimiter="---" --gfm -t xml -o $@ $^

_build/CommonMark.dtd: $(CM_DTD)
	cd _build; ln -sf ../$(CM_DTD)

posts/%.html: _build/%.xml | _xsl/head.xsl _xsl/post.xsl _build/CommonMark.dtd
	saxonb-xslt -xsl:_xsl/post.xsl -s:$^ -o:$@

CM_DTD := _commonmark_spec/CommonMark.dtd

$(CM_DTD):
	git submodule update --init commonmark-spec

.PHONY: xml
xml: $(POSTS_XML)

.PHONY: html
html: $(CM_DTD) $(POSTS_HTML)

index.html: $(POSTS_XML) | _xsl/head.xsl _xsl/index.xsl
	echo "<index/>" | saxonb-xslt -s:- -o:index.html -xsl:_xsl/index.xsl "files=$(POSTS_INDEX)"

about.html: _build/about.xml | _xsl/head.xsl _xsl/root-post.xsl _build/CommonMark.dtd
	saxonb-xslt -xsl:_xsl/root-post.xsl -s:_build/about.xml -o:about.html

tags.html: $(POSTS_XML) | _xsl/head.xsl _xsl/tags.xsl
	echo "<tags/>" | saxonb-xslt -s:- -o:tags.html -xsl:_xsl/tags.xsl "files=$(POSTS_INDEX)"

atom.xml: $(POSTS_XML) | _xsl/atom.xsl
	echo "<atom/>" | saxonb-xslt -s:- -o:atom.xml -xsl:_xsl/atom.xsl "files=$(POSTS_INDEX)" "blogUrl=$(BLOG_URL)"

sitemap.xml: $(POSTS_XML) | _xsl/sitemap.xsl
	echo "<sitemap/>" | saxonb-xslt -s:- -o:sitemap.xml -xsl:_xsl/sitemap.xsl "baseURL=$(BLOG_URL)/"

TEST_POST_MD := _posts/2023-07-24.markdown
TEST_POST_XML := _build/2023-07-24.xml
TEST_POST_HTML := posts/2023-07-24.html

.PHONY: test-render
test-render: $(CM_DTD)
	comrak --front-matter-delimiter="---" --gfm -t xml -o $(TEST_POST_XML) $(TEST_POST_MD)
	saxonb-xslt -xsl:_xsl/post.xsl -s:$(TEST_POST_XML) -o:$(TEST_POST_HTML)

.PHONY: serve
serve: all
	@echo "Starting local development server..."
	@echo "Blog will be available at: http://localhost:8080"
	docker compose up -d
	@echo "Server started! Use 'make serve-stop' to stop the server."

.PHONY: serve-stop
serve-stop:
	@echo "Stopping local development server..."
	docker compose down

.PHONY: serve-logs
serve-logs:
	docker compose logs -f blog-server

.PHONY: serve-restart
serve-restart: serve-stop serve

.PHONY: snapshot
snapshot: html index.html about.html tags.html
	@echo "Creating page snapshots using Docker + Chromium..."
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		zenika/alpine-chrome:latest \
		--no-sandbox \
		--headless \
		--disable-gpu \
		--window-size=1200,800 \
		--screenshot=_snapshots/index.png \
		file:///workspace/index.html
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		zenika/alpine-chrome:latest \
		--no-sandbox \
		--headless \
		--disable-gpu \
		--window-size=1200,800 \
		--screenshot=_snapshots/about.png \
		file:///workspace/about.html
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		zenika/alpine-chrome:latest \
		--no-sandbox \
		--headless \
		--disable-gpu \
		--window-size=1200,800 \
		--screenshot=_snapshots/tags.png \
		file:///workspace/tags.html
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		zenika/alpine-chrome:latest \
		--no-sandbox \
		--headless \
		--disable-gpu \
		--window-size=1200,800 \
		--screenshot=_snapshots/sample-post.png \
		file:///workspace/posts/2023-07-24.html

# New post creation
# Usage: make new-post TITLE="My Post Title" [DATE=YYYY-MM-DD] [TAGS="tag1, tag2, tag3"] [SUMMARY="Brief summary"]
NEW_POST_TITLE ?= New Blog Post
NEW_POST_DATE ?= $(shell date +%Y-%m-%d)
NEW_POST_TAGS ?= blog, draft
NEW_POST_SUMMARY ?= Brief description of the blog post content.

.PHONY: new-post
new-post:
	@if [ -z "$(TITLE)" ]; then \
		echo "Error: TITLE is required. Usage: make new-post TITLE=\"My Post Title\""; \
		exit 1; \
	fi
	@echo "Creating new blog post..."
	@NEW_POST_SLUG=$$(echo "$(TITLE)" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$$//g'); \
	NEW_POST_FILE="_posts/$(if $(DATE),$(DATE),$(NEW_POST_DATE))-$$NEW_POST_SLUG.markdown"; \
	if [ -f "$$NEW_POST_FILE" ]; then \
		echo "Error: Post file $$NEW_POST_FILE already exists"; \
		exit 1; \
	fi; \
	sed -e "s/{{TITLE}}/$(TITLE)/g" \
		-e "s/{{DATE}}/$(if $(DATE),$(DATE),$(NEW_POST_DATE))/g" \
		-e "s/{{TAGS}}/$(if $(TAGS),$(TAGS),$(NEW_POST_TAGS))/g" \
		-e "s/{{SUMMARY}}/$(if $(SUMMARY),$(SUMMARY),$(NEW_POST_SUMMARY))/g" \
		_templates/post-template.markdown > "$$NEW_POST_FILE"; \
	yq eval '.posts = ["'"$$NEW_POST_FILE"'"] + .posts' -i posts.yaml; \
	echo "Created: $$NEW_POST_FILE"; \
	echo "Added $$NEW_POST_FILE to posts.yaml (sorted by date)"

.PHONY: help-new-post
help-new-post:
	@echo "Create a new blog post from template:"
	@echo ""
	@echo "Usage:"
	@echo "  make new-post TITLE=\"My Post Title\" [DATE=YYYY-MM-DD] [TAGS=\"tag1, tag2\"] [SUMMARY=\"Brief summary\"]"
	@echo ""
	@echo "Parameters:"
	@echo "  TITLE    - Required: Title of the blog post"
	@echo "  DATE     - Optional: Publication date (default: today)"
	@echo "  TAGS     - Optional: Comma-separated tags (default: \"blog, draft\")"
	@echo "  SUMMARY  - Optional: Brief post summary (default: generic text)"
	@echo ""
	@echo "Examples:"
	@echo "  make new-post TITLE=\"Getting Started with XSLT\""
	@echo "  make new-post TITLE=\"Advanced CSS Grid\" DATE=2025-01-15 TAGS=\"css, web, design\""
	@echo "  make new-post TITLE=\"My New Feature\" SUMMARY=\"How I built this amazing feature\""
