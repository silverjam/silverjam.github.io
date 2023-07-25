xml:
	comrak --gfm -t xml <posts/2023-07-24.md >build/2023-07-24.xml

render:
	xsltproc xsl/markdown.xsl build/2023-07-24.xml >build/2023-07-24.html
