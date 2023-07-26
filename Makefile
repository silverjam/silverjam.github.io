POSTS_MD := \
	_posts/2023-07-24.markdown \
	_posts/2015-05-22-prius-total-cost-of-ownership.markdown \
	_posts/2015-04-19-least-bits-required-to-transmit-a-permutation.markdown \
	_posts/2014-03-06-cyanogenmod-aosp-and-vim-build-integration.markdown

POSTS_XML = $(POSTS_MD:_posts%markdown=_build%xml)

_SEMI := ;
_EMPTY :=
_SPACE := $(_EMPTY) $(_EMPTY)

_POSTS_INDEX = $(POSTS_MD:_posts%markdown=../_build%xml)
POSTS_INDEX = $(subst $(_SPACE),$(_SEMI),$(_POSTS_INDEX))

POSTS_HTML = $(POSTS_MD:_posts%markdown=posts%html)

all: html index.html

_build/%.xml: _posts/%.markdown
	comrak --gfm -t xml -o $@ $^

posts/%.html: _build/%.xml
	saxonb-xslt -xsl:xsl/post.xsl -s:$^ -o:$@

CM_DTD := commonmark-spec/CommonMark.dtd

$(CM_DTD):
	git submodule update --init commonmark-spec

xml: $(POSTS_XML)

html: $(CM_DTD) $(POSTS_HTML)

index.html: $(POSTS_XML)
	echo "<index/>" | saxonb-xslt -s:- -o:index.html -xsl:xsl/index.xsl "files=$(POSTS_INDEX)"

TEST_POST := _posts/2023-07-24.markdown

test-render: $(CM_DTD)
	saxonb-xslt -xsl:xsl/post.xsl $(TEST_POST) >posts/2023-07-24.html

.PHONY: xml html test-render
