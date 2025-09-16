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
      h1, h2, h3, h4 {
        --typography-spacing-vertical: 1rem;
      }
      article {
        margin-top: 1rem !important;
        padding-top: 1rem !important;
        margin-bottom: 1rem !important;
        padding-bottom: 1rem !important;
      }
      pre code {
        padding: 1em !important;
      }
      code {
        padding: 0.1rem 0.2rem !important;
      }
      header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.25rem 0 !important;
        border-bottom: 1px solid var(--muted-border-color);
        margin-bottom: 0;
        --block-spacing-vertical: 0.25rem;
      }
      header .logo {
        font-weight: bold;
        font-size: 1.2rem;
        text-decoration: none;
        color: var(--primary);
      }
      header nav {
        display: flex;
        gap: 1rem;
      }
      header nav a {
        text-decoration: none;
        color: var(--color);
        padding: 0.5rem;
        border-radius: var(--border-radius);
        transition: background-color 0.2s;
      }
      header nav a:hover {
        background-color: var(--secondary-focus);
      }
      body {
        margin: 0;
        padding: 0.5rem;
      }
      main {
        margin-top: 0.5rem;
      }
    </style>
  </head>

</xsl:template>

<xsl:template name="header">
  <xsl:param name="baseURL" select="''" />
  <header>
    <a href="{$baseURL}index.html" class="logo">Blog</a>
    <nav>
      <a href="{$baseURL}about.html">About</a>
      <a href="{$baseURL}tags.html">Tags</a>
    </nav>
  </header>
</xsl:template>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->
