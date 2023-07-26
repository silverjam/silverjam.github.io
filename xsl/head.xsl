<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cm="http://commonmark.org/xml/1.0"
  exclude-result-prefixes="cm"
>

<xsl:template name="head">

  <xsl:param name="title" />

  <head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@1/css/pico.classless.min.css"/>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.7.0/build/styles/base16/material-palenight.min.css" />
    <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.7.0/build/highlight.min.js"></script>
    <title>
      <xsl:value-of select="$title" />
    </title>
    <style>
      .hljs {
        font-family: "Menlo","Consolas","Roboto Mono","Ubuntu Monospace","Noto Mono","Oxygen Mono","Liberation Mono",monospace,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";
        font-size: 16px;
      }
      :root {
        --typography-spacing-vertical: 0.75rem;
      }
      h1, h2 {
        --typography-spacing-vertical: 1rem;
      }
      pre code {
        padding: 1em !important;
      }
      code {
        padding: 0.1rem 0.2rem !important;
      }
    </style>
  </head>

</xsl:template>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->
