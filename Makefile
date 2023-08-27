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

all: html index.html
.PHONY: all

_build/%.xml: _posts/%.markdown
	comrak --gfm -t xml -o $@ $^

_build/CommonMark.dtd: $(CM_DTD)
	cd _build; ln -sf ../$(CM_DTD) ../_build/CommonMark.dtd

posts/%.html: _build/%.xml | xsl/head.xsl xsl/post.xsl _build/CommonMark.dtd
	saxonb-xslt -xsl:xsl/post.xsl -s:$^ -o:$@

CM_DTD := commonmark-spec/CommonMark.dtd

$(CM_DTD):
	git submodule update --init commonmark-spec

xml: $(POSTS_XML)
.PHONY: xml

html: $(CM_DTD) $(POSTS_HTML)
.PHONY: html

index.html: $(POSTS_XML) | xsl/head.xsl xsl/index.xsl
	echo "<index/>" | saxonb-xslt -s:- -o:index.html -xsl:xsl/index.xsl "files=$(POSTS_INDEX)"

TEST_POST_MD := _posts/2023-07-24.markdown
TEST_POST_XML := _build/2023-07-24.xml
TEST_POST_HTML := posts/2023-07-24.html

test-render: $(CM_DTD)
	comrak --gfm -t xml -o $(TEST_POST_XML) $(TEST_POST_MD)
	saxonb-xslt -xsl:xsl/post.xsl -s:$(TEST_POST_XML) -o:$(TEST_POST_HTML)

.PHONY: test-render
