<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:cm="http://commonmark.org/xml/1.0"
  exclude-result-prefixes="cm xs"
>

<xsl:output method="xml" encoding="UTF-8" indent="yes" />

<xsl:param name="files" />
<xsl:param name="blogUrl" />

<xsl:template match="/atom">
  <feed xmlns="http://www.w3.org/2005/Atom">
    <title>A blog by Jason Mobarak</title>
    <link href="{$blogUrl}/" />
    <link rel="self" href="{$blogUrl}/atom.xml" />
    <id><xsl:value-of select="$blogUrl" />/</id>
    <updated><xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]Z')" /></updated>
    <subtitle>Personal blog featuring software development, technology, and various projects</subtitle>
    <generator uri="https://github.com/silverjam/blog" version="1.0">XSLT Static Site Generator</generator>
    <author>
      <name>Jason Mobarak</name>
      <uri><xsl:value-of select="$blogUrl" />/</uri>
    </author>

    <!-- Process all posts -->
    <xsl:for-each select="tokenize($files, ';')">
      <xsl:variable name="doc" select="document(.)" />

      <!-- Extract categories -->
      <xsl:variable name="categories" select="
        $doc
        //cm:table_cell/cm:text[contains(text(),'Categories')]
        /..
        /following-sibling::*
        /cm:text/text()
      " />

      <!-- Only include non-archive and non-draft posts -->
      <xsl:if test="not(contains($categories, 'archive')) and not(contains($categories, 'draft'))">

        <!-- Extract post metadata -->
        <xsl:variable name="title" select="$doc/cm:document/cm:heading[@level=1][1]/cm:text/text()" />

        <xsl:variable name="date" select="
          $doc
          //cm:table_cell/cm:text[contains(text(),'Date')]
          /..
          /following-sibling::*
          /cm:text/text()
        " />

        <xsl:variable name="summary" select="
          $doc
          //cm:table_cell/cm:text[contains(text(),'Metadata')]
          /../../..
          /following-sibling::*
          //cm:text[contains(text(),'SUMMARY:')]
          /..
          //text()
        " />

        <!-- Build post URL -->
        <xsl:variable name="post-file" select="tokenize(., '/')[last()]" />
        <xsl:variable name="post-html" select="replace($post-file, '.xml', '.html')" />
        <xsl:variable name="post-url" select="concat($blogUrl, '/posts/', $post-html)" />

        <!-- Convert date to Atom format (ISO 8601) -->
        <xsl:variable name="atom-date">
          <xsl:choose>
            <xsl:when test="$date">
              <!-- Convert YYYY-MM-DD to ISO 8601 format -->
              <xsl:value-of select="concat($date, 'T12:00:00Z')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]Z')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <entry>
          <title><xsl:value-of select="$title" /></title>
          <link href="{$post-url}" />
          <id><xsl:value-of select="$post-url" /></id>
          <updated><xsl:value-of select="$atom-date" /></updated>
          <published><xsl:value-of select="$atom-date" /></published>
          <author>
            <name>Jason Mobarak</name>
            <uri><xsl:value-of select="$blogUrl" />/</uri>
          </author>

          <!-- Add categories -->
          <xsl:if test="$categories">
            <xsl:for-each select="tokenize($categories, ',')">
              <category term="{normalize-space(.)}" />
            </xsl:for-each>
          </xsl:if>

          <!-- Summary -->
          <xsl:if test="$summary">
            <summary type="text">
              <xsl:for-each select="$summary">
                <xsl:value-of select="replace(., 'SUMMARY:', '')" />
                <xsl:text> </xsl:text>
              </xsl:for-each>
            </summary>
          </xsl:if>

          <!-- Content -->
          <content type="text">
            <!-- Add summary if available -->
            <xsl:if test="$summary">
              <xsl:for-each select="$summary">
                <xsl:value-of select="replace(., 'SUMMARY:', '')" />
                <xsl:text> </xsl:text>
              </xsl:for-each>
            </xsl:if>
          </content>
        </entry>
      </xsl:if>
    </xsl:for-each>
  </feed>
</xsl:template>


</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->
