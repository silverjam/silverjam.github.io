<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cm="http://commonmark.org/xml/1.0"
  exclude-result-prefixes="cm"
>

<xsl:import href="head.xsl" />

<xsl:output method="html" encoding="UTF-8" indent="yes" />

<xsl:param name="files" />

<xsl:template name="render-post-item">
  <xsl:param name="doc" />
  <xsl:param name="path" />

  <xsl:variable
    name="title"
    select="$doc/cm:document/cm:heading[@level=1][1]/cm:text/text()"
  />

  <xsl:variable
    name="date"
    select="
      $doc
      //cm:table_cell/cm:text[contains(text(),'Metadata')]
      /../../..
      //cm:table_cell/cm:text[contains(text(),'Date')]
      /..
      /following-sibling::*
      /cm:text/text()
    "
  />

  <xsl:variable
    name="summary"
    select="
      $doc
      //cm:table_cell/cm:text[contains(text(),'Metadata')]
      /../../..
      /following-sibling::*
      //cm:text[contains(text(),'SUMMARY:')]
      /..
      //text()
    "
  />

  <xsl:variable name="target_xml" select="tokenize($path, '/')[last()]" />
  <xsl:variable name="target_html" select="replace($target_xml, '.xml', '.html')" />

  <li>
    <a href="{concat('posts/', $target_html)}">
      <xsl:value-of select="$title" />
    </a>
    <em>[<xsl:value-of select="$date" />]</em>

    <xsl:if test="$summary">
      <ul>
        <li>
          <xsl:for-each select="$summary">
            <span><xsl:value-of select="replace(., 'SUMMARY:', '')" /><xsl:text> </xsl:text></span>
          </xsl:for-each>
        </li>
      </ul>
    </xsl:if>
  </li>
</xsl:template>

<xsl:template match="/archive">
  <html lang="en">
    <xsl:call-template name="head">
      <xsl:with-param name="title" select='"Archive - A blog by Jason Mobarak"' />
      <xsl:with-param name="baseURL" select="''" />
    </xsl:call-template>

    <body>
      <xsl:call-template name="header" />
      <main>
        <h1>Archive</h1>
        <p><em>A selection of preserved posts from older blogs.</em></p>

        <ul>
          <xsl:for-each select="tokenize($files, ';')">
            <xsl:variable name="doc" select="document(.)" />
            <xsl:variable
              name="categories"
              select="
                $doc
                //cm:table_cell/cm:text[contains(text(),'Metadata')]
                /../../..
                //cm:table_cell/cm:text[contains(text(),'Categories')]
                /..
                /following-sibling::*
                /cm:text/text()
              "
            />

            <xsl:if test="contains($categories, 'archive') and not(contains($categories, 'hidden'))">
              <xsl:call-template name="render-post-item">
                <xsl:with-param name="doc" select="$doc" />
                <xsl:with-param name="path" select="." />
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </ul>
      </main>
      <xsl:call-template name="footer">
        <xsl:with-param name="baseURL" select="''" />
      </xsl:call-template>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->
