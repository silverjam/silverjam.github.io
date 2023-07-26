<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cm="http://commonmark.org/xml/1.0"
  exclude-result-prefixes="cm"
>

<xsl:import href="head.xsl" />

<xsl:output method="html" encoding="UTF-8" indent="yes" />

<xsl:template match="/cm:document">
  <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
</xsl:text>
  <html lang="en">
    <xsl:call-template name="head">
      <xsl:with-param
        name="title"
        select='/cm:document/cm:heading[@level=1][1]/cm:text/text()'
        />
    </xsl:call-template>
    <body>
      <main>
        <xsl:apply-templates select="*" />
      </main>
      <script>hljs.highlightAll();</script>
    </body>
  </html>
</xsl:template>

<xsl:template match="cm:heading[@level=1]">
  <h1><xsl:value-of select="cm:text/text()" /></h1>
</xsl:template>

<xsl:template match="cm:heading[@level=2]">
  <h2><xsl:value-of select="cm:text/text()" /></h2>
</xsl:template>

<xsl:template match="cm:heading[@level=3]">
  <h3><xsl:value-of select="cm:text/text()" /></h3>
</xsl:template>

<xsl:template match="cm:heading[@level=4]">
  <h4><xsl:value-of select="cm:text/text()" /></h4>
</xsl:template>

<xsl:template match="cm:paragraph">
  <p><xsl:apply-templates select="*" /></p>
</xsl:template>

<xsl:template match="cm:strong">
  <strong><xsl:apply-templates select="*" /></strong>
</xsl:template>

<xsl:template match="cm:text">
  <xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="cm:code">
  <code><xsl:value-of select="text()"/></code>
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

<xsl:template match="cm:table">
  <table>
    <thead>
      <xsl:apply-templates select="cm:table_row[1]" />
    </thead>
    <tbody>
      <xsl:apply-templates select="cm:table_row[1]/following-sibling::*" />
    </tbody>
  </table>
</xsl:template>

<xsl:template match="cm:table_row">
  <tr>
    <xsl:apply-templates select="cm:table_cell" />
  </tr>
</xsl:template>

<xsl:template match="cm:table_cell">
  <td>
    <xsl:apply-templates select="*" />
  </td>
</xsl:template>

<xsl:template match="cm:thematic_break">
  <hr/>
</xsl:template>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->
