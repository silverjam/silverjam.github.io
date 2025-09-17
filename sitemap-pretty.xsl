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
          body {
            margin: 0;
            padding: 0.5rem;
          }
          main {
            margin-top: 0.5rem;
          }
          table {
            width: 100%;
            margin-top: 1rem;
          }
          .url-column {
            font-family: monospace;
            word-break: break-all;
            font-size: 0.875rem;
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
