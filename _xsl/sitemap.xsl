<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cm="http://commonmark.org/xml/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="baseURL" select="'https://silverjam.github.io/'"/>

  <xsl:template match="/">
    <xsl:processing-instruction name="xml-stylesheet">href="sitemap-pretty.xsl" type="text/xsl"</xsl:processing-instruction>
    <xsl:text>
</xsl:text>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      <!-- Homepage -->
      <url>
        <loc><xsl:value-of select="$baseURL"/></loc>
        <lastmod><xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/></lastmod>
        <changefreq>weekly</changefreq>
        <priority>1.0</priority>
      </url>

      <!-- About page -->
      <url>
        <loc><xsl:value-of select="$baseURL"/>about.html</loc>
        <lastmod><xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/></lastmod>
        <changefreq>monthly</changefreq>
        <priority>0.8</priority>
      </url>

      <!-- Tags page -->
      <url>
        <loc><xsl:value-of select="$baseURL"/>tags.html</loc>
        <lastmod><xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/></lastmod>
        <changefreq>weekly</changefreq>
        <priority>0.7</priority>
      </url>

      <!-- Blog posts -->
      <xsl:for-each select="collection('../_build/?select=*.xml')[not(contains(document-uri(.), 'about.xml'))]">
        <xsl:sort select="//cm:text[parent::cm:table_cell[preceding-sibling::cm:table_cell/cm:text[contains(text(), 'Date')]]]" order="descending"/>
        <xsl:variable name="filename" select="replace(tokenize(document-uri(.), '/')[last()], '.xml$', '.html')"/>
        <xsl:variable name="date" select="//cm:text[parent::cm:table_cell[preceding-sibling::cm:table_cell/cm:text[contains(text(), 'Date')]]]"/>

        <url>
          <loc><xsl:value-of select="$baseURL"/>posts/<xsl:value-of select="$filename"/></loc>
          <lastmod><xsl:value-of select="$date"/></lastmod>
          <changefreq>yearly</changefreq>
          <priority>0.6</priority>
        </url>
      </xsl:for-each>
    </urlset>
  </xsl:template>

</xsl:stylesheet>
