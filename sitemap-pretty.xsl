<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:variable name="hostname" select="substring-before(substring-after(/sitemap:urlset/sitemap:url[1]/sitemap:loc, '://'), '/')" />

    <html>
      <head>
        <title>Sitemap - Jason Mobarak Blog</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta charset="UTF-8"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@1/css/pico.classless.min.css"/>
        <style>
          :root {
            --font-size: 17px;
            --typography-spacing-vertical: 0.75rem;
          }
          html {
            font-size: 15px;
            scroll-behavior: smooth;
          }
          body {
            margin: 0;
            padding: 0.5rem;
          }
          h1, h2, h3, h4 {
            --typography-spacing-vertical: 1rem;
          }
          h1 {
            font-size: 1.8rem;
            line-height: 1.2;
          }
          h2 {
            font-size: 1.5rem;
            line-height: 1.25;
          }
          h3 {
            font-size: 1.25rem;
            line-height: 1.3;
          }
          h4 {
            font-size: 1.1rem;
            line-height: 1.35;
          }
          main {
            max-width: 1200px;
            margin: 0.5rem auto 0;
          }
          header {
            border-bottom: 1px solid var(--muted-border-color);
            margin-bottom: 1.5rem;
            padding: 0.25rem 0 0.75rem;
          }
          header h1 {
            margin-bottom: 0.35rem;
          }
          header p {
            margin: 0;
            color: var(--muted-color);
          }
          section {
            margin-top: 1rem;
          }
          table {
            width: 100%;
            margin-top: 1rem;
            font-size: 0.95rem;
          }
          th,
          td {
            vertical-align: top;
          }
          a {
            text-decoration: none;
          }
          a:hover {
            text-decoration: underline;
          }
          .url-column {
            font-family: monospace;
            word-break: break-all;
            font-size: 0.8125rem;
            color: var(--muted-color);
          }
          .priority-high { color: var(--primary); font-weight: bold; }
          .priority-medium { color: var(--secondary); }
          .priority-low { color: var(--muted-color); }
        </style>
      </head>
      <body>
        <main>
          <header>
            <h1>Sitemap</h1>
            <p>This page contains all URLs available on this website.</p>
          </header>

          <section>
            <h2>Pages (<xsl:value-of select="count(//sitemap:url)"/> total)</h2>

            <table>
              <thead>
                <tr>
                  <th>Page</th>
                  <th>URL</th>
                  <th>Last Modified</th>
                  <th>Change Frequency</th>
                  <th>Priority</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="//sitemap:url">
                  <xsl:sort select="sitemap:priority" order="descending"/>
                  <xsl:sort select="sitemap:lastmod" order="descending"/>

                  <tr>
                    <td>
                      <a href="{sitemap:loc}">
                        <xsl:choose>
                          <xsl:when test="contains(sitemap:loc, '/posts/')">
                            <xsl:variable name="filename" select="substring-after(sitemap:loc, '/posts/')"/>
                            <xsl:value-of select="substring-before($filename, '.html')"/>
                          </xsl:when>
                          <xsl:when test="substring(sitemap:loc, string-length(sitemap:loc)) = '/'">
                            Homepage
                          </xsl:when>
                          <xsl:when test="contains(sitemap:loc, 'about.html')">
                            About
                          </xsl:when>
                          <xsl:when test="contains(sitemap:loc, 'tags.html')">
                            Tags
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="sitemap:loc"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </a>
                    </td>
                    <td class="url-column">
                      <xsl:value-of select="sitemap:loc"/>
                    </td>
                    <td>
                      <xsl:value-of select="sitemap:lastmod"/>
                    </td>
                    <td>
                      <xsl:value-of select="sitemap:changefreq"/>
                    </td>
                    <td>
                      <xsl:attribute name="class">
                        <xsl:choose>
                          <xsl:when test="sitemap:priority &gt;= 0.8">priority-high</xsl:when>
                          <xsl:when test="sitemap:priority &gt;= 0.6">priority-medium</xsl:when>
                          <xsl:otherwise>priority-low</xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:value-of select="sitemap:priority"/>
                    </td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </section>
        </main>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
