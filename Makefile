xml:
	comrak --front-matter-delimiter "---" --gfm -t xml posts/2015-05-22-prius-total-cost-of-ownership.markdown >build/post1.xml
	comrak --front-matter-delimiter "---" --gfm -t xml posts/2015-04-19-least-bits-required-to-transmit-a-permutation.markdown >build/post2.xml
	comrak --front-matter-delimiter "---" --gfm -t xml posts/2023-07-24.markdown >build/post3.xml

render:
	cp commonmark-spec/CommonMark.dtd build/CommonMark.dtd
	xsltproc xsl/markdown.xsl build/post3.xml >index.html
