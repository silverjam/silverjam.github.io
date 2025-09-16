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

<xsl:template match="/index">

  <html lang="en">

    <xsl:call-template name="head">
      <xsl:with-param name="title" select='"A blog by Jason Mobarak"' />
      <xsl:with-param name="baseURL" select="''" />
    </xsl:call-template>

    <body>
      <xsl:call-template name="header" />
      <main>
        <!-- Recent Posts Section -->
        <h2>Recent Posts</h2>
        <ul>
          <xsl:for-each select="tokenize($files, ';')">
            <xsl:variable
              name="doc"
              select="document(.)"
              />

            <!-- CATEGORIES: find the 'Metadata' table, then find the 'Categories' field within the table -->
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

            <!-- Only show posts that don't contain 'archive' in categories -->
            <xsl:if test="not(contains($categories, 'archive'))">
              <li>
                <!-- TITLE: the first level 1 heading, is the post title -->
                <xsl:variable
                  name="title"
                  select="$doc/cm:document/cm:heading[@level=1][1]/cm:text/text()"
                  />

                <!-- DATE: find the 'Metadata' table, then find the 'Date' field within the table -->
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

                <!-- SUMMARY: find the 'Metadata' table, then find the text block that starts with 'SUMMARY:' immediately following -->
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

                <!-- Build up a path to the generated .html using the .xml filename -->
                <xsl:variable
                  name="target_xml"
                  select="tokenize(., '/')[last()]"
                  />
                <xsl:variable
                  name="target_html"
                  select="replace($target_xml, '.xml', '.html')"
                  />

                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('posts/', $target_html)" />
                  </xsl:attribute>
                  <xsl:value-of select="$title" />
                </a>

                <em>
                  [<xsl:value-of select="$date" />]
                </em>

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
            </xsl:if>
          </xsl:for-each>
        </ul>

        <!-- Archive Section -->
        <h2>Archive</h2>
        <ul>
          <xsl:for-each select="tokenize($files, ';')">
            <xsl:variable
              name="doc"
              select="document(.)"
              />

            <!-- CATEGORIES: find the 'Metadata' table, then find the 'Categories' field within the table -->
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

            <!-- Only show posts that contain 'archive' in categories -->
            <xsl:if test="contains($categories, 'archive')">
              <li>
                <!-- TITLE: the first level 1 heading, is the post title -->
                <xsl:variable
                  name="title"
                  select="$doc/cm:document/cm:heading[@level=1][1]/cm:text/text()"
                  />

                <!-- DATE: find the 'Metadata' table, then find the 'Date' field within the table -->
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

                <!-- SUMMARY: find the 'Metadata' table, then find the text block that starts with 'SUMMARY:' immediately following -->
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

                <!-- Build up a path to the generated .html using the .xml filename -->
                <xsl:variable
                  name="target_xml"
                  select="tokenize(., '/')[last()]"
                  />
                <xsl:variable
                  name="target_html"
                  select="replace($target_xml, '.xml', '.html')"
                  />

                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('posts/', $target_html)" />
                  </xsl:attribute>
                  <xsl:value-of select="$title" />
                </a>

                <em>
                  [<xsl:value-of select="$date" />]
                </em>

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
            </xsl:if>
          </xsl:for-each>
        </ul>
      </main>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->
