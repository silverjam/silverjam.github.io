<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cm="http://commonmark.org/xml/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="http://local.functions"
  exclude-result-prefixes="cm xs local"
>

<xsl:import href="head.xsl" />

<xsl:output method="html" encoding="UTF-8" indent="yes" />

<xsl:variable name="title" select="/cm:document/cm:heading[@level=1][1]" />
<xsl:variable name="start" select="/cm:document/cm:thematic_break[1]" />

<!-- Function to generate URL-safe IDs from heading text -->
<xsl:function name="local:generate-id" as="xs:string">
  <xsl:param name="text" as="xs:string"/>
  <xsl:value-of select="translate(lower-case(normalize-space($text)), ' .,!?;:()', '----')"/>
</xsl:function>

<xsl:template match="/cm:document">
  <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
</xsl:text>
  <html lang="en">
    <xsl:call-template name="head">
      <xsl:with-param
        name="title"
        select='$title/cm:text/text()'
        />
      <xsl:with-param name="baseURL" select="'../'" />
    </xsl:call-template>
    <body>
      <xsl:call-template name="header">
        <xsl:with-param name="baseURL" select="'../'" />
      </xsl:call-template>
      <main>
        <xsl:apply-templates select="$start/preceding-sibling::*" />

        <div class="post-layout">
          <div class="post-content">
            <article>
              <xsl:apply-templates select="$start/following-sibling::*" />
            </article>
          </div>

          <div class="post-sidebar">
            <xsl:call-template name="table-of-contents" />
          </div>
        </div>
      </main>
      <xsl:call-template name="footer">
        <xsl:with-param name="baseURL" select="'../'" />
      </xsl:call-template>
      <script>hljs.highlightAll();</script>
    </body>
  </html>
</xsl:template>

<!-- Template to generate table of contents -->
<xsl:template name="table-of-contents">
  <xsl:variable name="headings" select="$start/following-sibling::cm:heading[@level &gt;= 2 and @level &lt;= 4]" />

  <xsl:if test="$headings">
    <div class="toc">
      <h3>Table of Contents</h3>
      <ul>
        <xsl:for-each select="$headings">
          <xsl:variable name="heading-text" select="cm:text/text()" />
          <xsl:variable name="heading-id" select="local:generate-id($heading-text)" />
          <xsl:variable name="level" select="@level" />

          <li>
            <a href="#{$heading-id}" class="toc-h{$level}">
              <xsl:value-of select="$heading-text" />
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="cm:heading[@level=1]">
  <h1><xsl:value-of select="cm:text/text()" /></h1>
</xsl:template>

<xsl:template match="cm:heading[@level=2]">
  <xsl:variable name="heading-text" select="cm:text/text()" />
  <h2 id="{local:generate-id($heading-text)}">
    <xsl:value-of select="$heading-text" />
  </h2>
</xsl:template>

<xsl:template match="cm:heading[@level=3]">
  <xsl:variable name="heading-text" select="cm:text/text()" />
  <h3 id="{local:generate-id($heading-text)}">
    <xsl:value-of select="$heading-text" />
  </h3>
</xsl:template>

<xsl:template match="cm:heading[@level=4]">
  <xsl:variable name="heading-text" select="cm:text/text()" />
  <h4 id="{local:generate-id($heading-text)}">
    <xsl:value-of select="$heading-text" />
  </h4>
</xsl:template>

<xsl:template match="cm:paragraph">
  <p><xsl:apply-templates select="*" /></p>
</xsl:template>

<xsl:template match="cm:strong">
  <strong><xsl:apply-templates select="*" /></strong>
</xsl:template>

<xsl:template match="cm:emph">
  <em><xsl:apply-templates select="*" /></em>
</xsl:template>

<xsl:template match="cm:strikethrough">
  <s><xsl:apply-templates select="*" /></s>
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

<!-- Special template for Categories table cell -->
<xsl:template match="cm:table_cell[preceding-sibling::cm:table_cell/cm:text[contains(text(), 'Categories')]]">
  <td>
    <xsl:variable name="categories" select="cm:text/text()" />
    <xsl:for-each select="tokenize($categories, ',')">
      <xsl:variable name="category" select="normalize-space(.)" />
      <xsl:variable name="category-id" select="translate($category, ' ', '-')" />

      <xsl:if test="position() > 1">, </xsl:if>
      <a href="../tags.html#{$category-id}">
        <xsl:value-of select="$category" />
      </a>
    </xsl:for-each>
  </td>
</xsl:template>

<xsl:template match="cm:thematic_break">
  <hr/>
</xsl:template>

<xsl:template match="cm:list[@type='bullet']">
  <ul>
    <xsl:apply-templates select="cm:item" />
  </ul>
</xsl:template>

<xsl:template match="cm:list[@type='ordered']">
  <ol>
    <xsl:if test="@start and @start != '1'">
      <xsl:attribute name="start">
        <xsl:value-of select="@start"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="cm:item" />
  </ol>
</xsl:template>

<xsl:template match="cm:item">
  <li>
    <xsl:apply-templates select="*" />
  </li>
</xsl:template>

<xsl:template match="cm:link">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="@destination" />
    </xsl:attribute>
    <xsl:apply-templates />
  </a>
</xsl:template>

<!-- ==================================================================== -->
<!-- Borrowed from: https://github.com/vieiro/xmark/blob/master/xmark.xsl -->
<!-- ==================================================================== -->

<!-- custom HTML entries in markdown are processed here -->
<!--
     Hack template to generate HTML elements from escaped stuff
     &gt;/hola> will generate </hola>
-->
<xsl:template name='html-end'>
  <xsl:param name='text' />
  <xsl:choose>
    <xsl:when test='contains($text, "&gt;")'>
      <xsl:value-of select='substring-before($text, "&gt;")' />
      <xsl:text disable-output-escaping='yes'>&gt;</xsl:text>
      <xsl:call-template name='html-start'>
              <xsl:with-param name='text' select='substring-after($text, "&gt;")' />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name='html-start'>
        <xsl:with-param name='text' select='$text' />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- 
     template function to generate a start element 
     &myhtml; will generate <myhtml>
-->
<xsl:template name='html-start'>
  <xsl:param name='text' />
  <xsl:choose>
    <xsl:when test='contains($text, "&lt;")'>
      <xsl:value-of select='substring-before($text, "&lt;")' />
      <xsl:text disable-output-escaping='yes'>&lt;</xsl:text>
      <xsl:call-template name='html-end'>
        <xsl:with-param name='text' select='substring-after($text, "&lt;")' />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='$text' />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cm:html_block">
  <xsl:call-template name='html-start'>
    <xsl:with-param name='text' select='text()' />
  </xsl:call-template>
  <xsl:apply-templates />
  <!--
    Commonmark translates escapes HTML stuff in the XML tree, so, for instance
    <aside> becomes &lt;aside&gt;
    We would like to replace all &lt; with < and &gt; with > but this is challenging in XSL.
    Mainly because XSL forbits '<' in attribute values to avoid the resulting XML being
    malformed.
  -->
</xsl:template>

<xsl:template match="cm:softbreak">
  <xsl:text> 
</xsl:text>
</xsl:template>

<!-- Presumably this just gobbles up stray text in the markdown doc -->
<xsl:template match="text()"/>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->
