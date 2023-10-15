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
    </xsl:call-template>
    <body>
      <main>
        <ul>
          <xsl:for-each select="tokenize($files, ';')">
            <li>
              <xsl:variable
                name="title"
                select="document(.)/cm:document/cm:heading[@level=1][1]/cm:text/text()"
                />
              <xsl:variable
                name="target_xml"
                select="tokenize(., '/')[last()]"
                />
              <xsl:variable
                name="target_html"
                select="replace($target_xml, '.xml', '.html')"
                />
              <!-- Find the 'Metadata' table, then find the 'Date' field within the table -->
              <xsl:variable
                name="date"
                select="
                  document(.)
                  //cm:table_cell/cm:text[contains(text(),'Metadata')]
                  /../../..
                  //cm:table_cell/cm:text[contains(text(),'Date')]
                  /..
                  /following-sibling::*
                  /cm:text
                  /text()
                "
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
            </li>
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
