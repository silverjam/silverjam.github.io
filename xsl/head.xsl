<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cm="http://commonmark.org/xml/1.0"
  exclude-result-prefixes="cm"
>

<xsl:template name="head">

  <xsl:param name="title" />
  <xsl:param name="baseURL" select="''" />

  <head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@1/css/pico.classless.min.css"/>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.7.0/build/styles/base16/material-palenight.min.css" />
    <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.7.0/build/highlight.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="alternate" type="application/atom+xml" title="A blog by Jason Mobarak" href="{$baseURL}atom.xml" />
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
      footer {
        margin-top: 2rem;
        padding: 1rem 0;
        border-top: 1px solid var(--muted-border-color);
        text-align: center;
        font-size: 0.875rem;
        color: var(--muted-color);
      }
      footer .social-links {
        margin: 1rem 0;
      }
      footer .social-links a {
        margin: 0 0.5rem;
        color: var(--muted-color);
        text-decoration: none;
        font-size: 1.25rem;
        transition: color 0.2s;
      }
      footer .social-links a:hover {
        color: var(--primary);
      }
      footer .copyright {
        margin: 0.5rem 0;
      }
      footer .license {
        margin: 0.5rem 0;
        font-size: 0.8rem;
      }
    </style>
  </head>

</xsl:template>

<xsl:template name="header">
  <xsl:param name="baseURL" select="''" />
  <header>
    <a href="{if ($baseURL = '') then '/' else $baseURL}" class="logo">Jason Mobarak - Weblog</a>
    <nav>
      <a href="{$baseURL}about.html"><i class="fas fa-user"></i> About</a>
      <a href="{$baseURL}tags.html"><i class="fas fa-tags"></i> Tags</a>
      <a href="{$baseURL}atom.xml"><i class="fas fa-rss"></i> Feed</a>
      <a href="https://github.com/silverjam/silverjam.github.io"><i class="fab fa-github"></i> GitHub</a>
    </nav>
  </header>
</xsl:template>

<xsl:template name="footer">
  <footer>
    <div class="social-links">
      <a href="https://github.com/silverjam" title="GitHub" aria-label="GitHub">
        <i class="fab fa-github"></i>
      </a>
      <a href="https://hachyderm.io/@silverjam" title="Mastodon" aria-label="Mastodon">
        <i class="fab fa-mastodon"></i>
      </a>
      <a href="https://www.threads.com/@silv3rjam" title="Threads" aria-label="Threads">
        <i class="fa-brands fa-threads"></i>
      </a>
      <a href="https://www.instagram.com/silv3rjam/" title="Instagram" aria-label="Instagram">
        <i class="fab fa-instagram"></i>
      </a>
      <a href="https://www.linkedin.com/in/silverjam" title="LinkedIn" aria-label="LinkedIn">
        <i class="fab fa-linkedin"></i>
      </a>
    </div>
    <div class="copyright">
      © <xsl:value-of select="format-date(current-date(), '[Y]')" /> Jason Mobarak
    </div>
    <div class="license">
      <a href="https://creativecommons.org/licenses/by-sa/4.0/" rel="license">
        <i class="fab fa-creative-commons"></i>
        <i class="fab fa-creative-commons-by"></i>
        <i class="fab fa-creative-commons-sa"></i>
      </a>
      This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License
      · <a href="sitemap.xml">Sitemap</a>
    </div>
  </footer>
</xsl:template>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->
