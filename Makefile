POSTS_MD := \
	_posts/2023-07-24.markdown \
	_posts/2015-05-22-prius-total-cost-of-ownership.markdown \
	_posts/2015-04-19-least-bits-required-to-transmit-a-permutation.markdown \
	_posts/2014-03-06-cyanogenmod-aosp-and-vim-build-integration.markdown \
	_posts/2013-06-05-android-build-tools-snafu.markdown

POSTS_XML = $(POSTS_MD:_posts%markdown=_build%xml)

_SEMI := ;
_EMPTY := 
_SPACE := $(_EMPTY) $(_EMPTY)

_POSTS_INDEX = $(POSTS_MD:_posts%markdown=../_build%xml)
POSTS_INDEX = $(subst $(_SPACE),$(_SEMI),$(_POSTS_INDEX))

POSTS_HTML = $(POSTS_MD:_posts%markdown=posts%html)

COMRAK_VERSION := 0.41.1
SAXON_VERSION := 9.1.0.8J

.PHONY: all
all: check-comrak-version check-saxon-version html index.html about.html tags.html

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

.PHONY: install-deps
install-deps: install-comrak install-saxonb

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

posts/%.html: _build/%.xml | xsl/head.xsl xsl/post.xsl _build/CommonMark.dtd
	saxonb-xslt -xsl:xsl/post.xsl -s:$^ -o:$@

CM_DTD := commonmark-spec/CommonMark.dtd

$(CM_DTD):
	git submodule update --init commonmark-spec

.PHONY: xml
xml: $(POSTS_XML)

.PHONY: html
html: $(CM_DTD) $(POSTS_HTML)

index.html: $(POSTS_XML) | xsl/head.xsl xsl/index.xsl
	echo "<index/>" | saxonb-xslt -s:- -o:index.html -xsl:xsl/index.xsl "files=$(POSTS_INDEX)"

about.html: _build/about.xml | xsl/head.xsl xsl/root-post.xsl _build/CommonMark.dtd
	saxonb-xslt -xsl:xsl/root-post.xsl -s:_build/about.xml -o:about.html

tags.html: $(POSTS_XML) | xsl/head.xsl xsl/tags.xsl
	echo "<tags/>" | saxonb-xslt -s:- -o:tags.html -xsl:xsl/tags.xsl "files=$(POSTS_INDEX)"

TEST_POST_MD := _posts/2023-07-24.markdown
TEST_POST_XML := _build/2023-07-24.xml
TEST_POST_HTML := posts/2023-07-24.html

.PHONY: test-render
test-render: $(CM_DTD)
	comrak --front-matter-delimiter="---" --gfm -t xml -o $(TEST_POST_XML) $(TEST_POST_MD)
	saxonb-xslt -xsl:xsl/post.xsl -s:$(TEST_POST_XML) -o:$(TEST_POST_HTML)

.PHONY: snapshot-check
snapshot-check:
	@command -v docker >/dev/null 2>&1 || (echo "Error: Docker is required for snapshots. Install Docker first." && exit 1)
	@echo "Docker found. Ready for snapshots."

.PHONY: snapshot
snapshot: snapshot-check html index.html about.html tags.html
	@echo "Creating page snapshots using Docker + Chromium..."
	@mkdir -p snapshots
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		zenika/alpine-chrome:latest \
		--no-sandbox \
		--headless \
		--disable-gpu \
		--window-size=1200,800 \
		--screenshot=snapshots/index.png \
		file:///workspace/index.html
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		zenika/alpine-chrome:latest \
		--no-sandbox \
		--headless \
		--disable-gpu \
		--window-size=1200,800 \
		--screenshot=snapshots/about.png \
		file:///workspace/about.html
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		zenika/alpine-chrome:latest \
		--no-sandbox \
		--headless \
		--disable-gpu \
		--window-size=1200,800 \
		--screenshot=snapshots/tags.png \
		file:///workspace/tags.html
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		zenika/alpine-chrome:latest \
		--no-sandbox \
		--headless \
		--disable-gpu \
		--window-size=1200,800 \
		--screenshot=snapshots/sample-post.png \
		file:///workspace/posts/2023-07-24.html
