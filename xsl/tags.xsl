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

<xsl:template match="/tags">

  <html lang="en">

    <xsl:call-template name="head">
      <xsl:with-param name="title" select='"Tags - A blog by Jason Mobarak"' />
    </xsl:call-template>

    <body>
      <xsl:call-template name="header" />
      <main>
        <h1>Tags</h1>

        <!-- Collect all categories from all posts -->
        <xsl:variable name="all-categories">
          <xsl:for-each select="tokenize($files, ';')">
            <xsl:variable name="doc" select="document(.)" />

            <!-- Extract categories from the metadata table -->
            <xsl:variable name="categories" select="
              $doc
              //cm:table_cell/cm:text[contains(text(),'Categories')]
              /..
              /following-sibling::*
              /cm:text/text()
            " />

            <!-- Split categories by comma and create category elements -->
            <xsl:if test="$categories">
              <xsl:for-each select="tokenize($categories, ',')">
                <category>
                  <xsl:attribute name="name" select="normalize-space(.)" />
                  <xsl:attribute name="post" select="tokenize(base-uri($doc), '/')[last()]" />
                </category>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>

        <!-- Group categories and display them -->
        <xsl:for-each-group select="$all-categories/category" group-by="@name">
          <xsl:sort select="current-grouping-key()" />
          <xsl:if test="normalize-space(current-grouping-key()) != ''">
            <h2><xsl:value-of select="current-grouping-key()" /></h2>
            <p><em><xsl:value-of select="count(current-group())" /> post<xsl:if test="count(current-group()) != 1">s</xsl:if></em></p>

            <ul>
              <xsl:for-each select="current-group()">
                <xsl:variable name="post-file" select="@post" />
                <xsl:variable name="doc" select="document(concat('../_build/', replace($post-file, '.xml', '.xml')))" />

                <!-- Get post title -->
                <xsl:variable name="title" select="$doc/cm:document/cm:heading[@level=1][1]/cm:text/text()" />

                <!-- Get post date -->
                <xsl:variable name="date" select="
                  $doc
                  //cm:table_cell/cm:text[contains(text(),'Date')]
                  /..
                  /following-sibling::*
                  /cm:text/text()
                " />

                <li>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="concat('posts/', replace($post-file, '.xml', '.html'))" />
                    </xsl:attribute>
                    <xsl:value-of select="$title" />
                  </a>
                  <em> [<xsl:value-of select="$date" />]</em>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </xsl:for-each-group>

      </main>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->