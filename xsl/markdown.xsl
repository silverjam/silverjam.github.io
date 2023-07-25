<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cm="http://commonmark.org/xml/1.0"
  exclude-result-prefixes="cm"
>

<xsl:output method="html" encoding="UTF-8" indent="yes" />

<xsl:template match="/cm:document">
  <html lang="en">
    <head>
      <!--
      <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css" />
      -->
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@1/css/pico.classless.min.css"/>
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <meta charset="UTF-8" />
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.7.0/build/styles/default.min.css" />
      <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.7.0/build/highlight.min.js"></script>
      <style>
      </style>
    </head>
    <body>
    <main>
      <xsl:apply-templates select="*" />
    </main>
    <script>hljs.highlightAll();</script>
    </body></html>
</xsl:template>

<xsl:template match="cm:heading[@level=1]">
  <h1><xsl:value-of select="cm:text/text()" /></h1>
</xsl:template>

<xsl:template match="cm:heading[@level=2]">
  <h2><xsl:value-of select="cm:text/text()" /></h2>
</xsl:template>

<xsl:template match="cm:paragraph">
  <p><xsl:value-of select="cm:text/text()" /></p>
</xsl:template>

<xsl:template match="cm:code_block">
  <pre><code>
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="@info"><xsl:text>language-</xsl:text><xsl:value-of select="@info"/></xsl:when>
        <xsl:otherwise>
          <xsl:text>language-plaintext</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:value-of select="text()" />
  </code></pre>
</xsl:template>

</xsl:stylesheet>
