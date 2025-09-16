<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cm="http://commonmark.org/xml/1.0"
  exclude-result-prefixes="cm"
>

<xsl:import href="post.xsl" />

<xsl:template match="/cm:document">
  <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
</xsl:text>
  <html lang="en">
    <xsl:call-template name="head">
      <xsl:with-param
        name="title"
        select='$title/cm:text/text()'
        />
      <xsl:with-param name="baseURL" select="''" />
    </xsl:call-template>
    <body>
      <xsl:call-template name="header">
        <xsl:with-param name="baseURL" select="''" />
      </xsl:call-template>
      <main>
        <xsl:apply-templates select="$start/preceding-sibling::*" />
        <article>
          <xsl:apply-templates select="$start/following-sibling::*" />
        </article>
      </main>
      <script>hljs.highlightAll();</script>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->