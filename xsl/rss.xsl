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

<xsl:template match="/rss">
  <rss version="2.0">
    <channel>
      <title>A blog by Jason Mobarak</title>
      <link><xsl:value-of select="$blogUrl" />/</link>
      <description>Personal blog featuring software development, technology, and various projects</description>
      <language>en-us</language>
      <generator>XSLT Static Site Generator</generator>
      <lastBuildDate><xsl:value-of select="format-dateTime(current-dateTime(), '[FNn,*-3], [D01] [MNn,*-3] [Y0001] [H01]:[m01]:[s01] GMT')" /></lastBuildDate>

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

        <!-- Only include non-archive posts -->
        <xsl:if test="not(contains($categories, 'archive'))">

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

          <!-- Convert date to RFC 2822 format -->
          <xsl:variable name="rfc-date">
            <xsl:choose>
              <xsl:when test="$date">
                <!-- Convert YYYY-MM-DD to RFC 2822 format -->
                <xsl:variable name="date-parts" select="tokenize($date, '-')" />
                <xsl:value-of select="format-date(xs:date($date), '[FNn,*-3], [D01] [MNn,*-3] [Y0001] 12:00:00 GMT')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="format-dateTime(current-dateTime(), '[FNn,*-3], [D01] [MNn,*-3] [Y0001] [H01]:[m01]:[s01] GMT')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <item>
            <title><xsl:value-of select="$title" /></title>
            <link><xsl:value-of select="$post-url" /></link>
            <guid><xsl:value-of select="$post-url" /></guid>
            <pubDate><xsl:value-of select="$rfc-date" /></pubDate>

            <!-- Add categories -->
            <xsl:if test="$categories">
              <xsl:for-each select="tokenize($categories, ',')">
                <category><xsl:value-of select="normalize-space(.)" /></category>
              </xsl:for-each>
            </xsl:if>

            <!-- Description with summary and full content -->
            <description>
              <xsl:text>&lt;![CDATA[</xsl:text>

              <!-- Add summary if available -->
              <xsl:if test="$summary">
                <xsl:for-each select="$summary">
                  <xsl:value-of select="replace(., 'SUMMARY:', '')" />
                  <xsl:text> </xsl:text>
                </xsl:for-each>
                <xsl:text>

</xsl:text>
              </xsl:if>

              <!-- Add full post content -->
              <xsl:apply-templates select="$doc/cm:document/cm:thematic_break[1]/following-sibling::*" mode="rss-content" />

              <xsl:text>]]&gt;</xsl:text>
            </description>
          </item>
        </xsl:if>
      </xsl:for-each>
    </channel>
  </rss>
</xsl:template>

<!-- Templates for converting CommonMark XML to HTML in RSS content -->
<xsl:template match="cm:heading[@level=2]" mode="rss-content">
  <xsl:text>&lt;h2&gt;</xsl:text>
  <xsl:value-of select="cm:text/text()" />
  <xsl:text>&lt;/h2&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:heading[@level=3]" mode="rss-content">
  <xsl:text>&lt;h3&gt;</xsl:text>
  <xsl:value-of select="cm:text/text()" />
  <xsl:text>&lt;/h3&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:heading[@level=4]" mode="rss-content">
  <xsl:text>&lt;h4&gt;</xsl:text>
  <xsl:value-of select="cm:text/text()" />
  <xsl:text>&lt;/h4&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:paragraph" mode="rss-content">
  <xsl:text>&lt;p&gt;</xsl:text>
  <xsl:apply-templates select="*" mode="rss-content" />
  <xsl:text>&lt;/p&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:strong" mode="rss-content">
  <xsl:text>&lt;strong&gt;</xsl:text>
  <xsl:apply-templates select="*" mode="rss-content" />
  <xsl:text>&lt;/strong&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:emph" mode="rss-content">
  <xsl:text>&lt;em&gt;</xsl:text>
  <xsl:apply-templates select="*" mode="rss-content" />
  <xsl:text>&lt;/em&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:text" mode="rss-content">
  <xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="cm:code" mode="rss-content">
  <xsl:text>&lt;code&gt;</xsl:text>
  <xsl:value-of select="text()"/>
  <xsl:text>&lt;/code&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:code_block" mode="rss-content">
  <xsl:text>&lt;pre&gt;&lt;code&gt;</xsl:text>
  <xsl:value-of select="text()" />
  <xsl:text>&lt;/code&gt;&lt;/pre&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:list[@type='bullet']" mode="rss-content">
  <xsl:text>&lt;ul&gt;</xsl:text>
  <xsl:apply-templates select="cm:item" mode="rss-content" />
  <xsl:text>&lt;/ul&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:list[@type='ordered']" mode="rss-content">
  <xsl:text>&lt;ol&gt;</xsl:text>
  <xsl:apply-templates select="cm:item" mode="rss-content" />
  <xsl:text>&lt;/ol&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:item" mode="rss-content">
  <xsl:text>&lt;li&gt;</xsl:text>
  <xsl:apply-templates select="*" mode="rss-content" />
  <xsl:text>&lt;/li&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:link" mode="rss-content">
  <xsl:text>&lt;a href="</xsl:text>
  <xsl:value-of select="@destination" />
  <xsl:text>"&gt;</xsl:text>
  <xsl:apply-templates mode="rss-content" />
  <xsl:text>&lt;/a&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:thematic_break" mode="rss-content">
  <xsl:text>&lt;hr/&gt;</xsl:text>
</xsl:template>

<xsl:template match="cm:softbreak" mode="rss-content">
  <xsl:text> </xsl:text>
</xsl:template>

<!-- Ignore other elements in RSS content mode -->
<xsl:template match="text()" mode="rss-content"/>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->