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
    <link rel="apple-touch-icon" sizes="180x180" href="/images/apple-touch-icon.png" />
    <link rel="icon" type="image/png" sizes="32x32" href="/images/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="/images/favicon-16x16.png" />
    <link rel="manifest" href="/site.webmanifest" />
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
        font-size: 14px;
      }
      :root {
        --font-size: 17px;
        --typography-spacing-vertical: 0.75rem;
        --toc-width: 16rem;
        --toc-indent-base: 1rem;
        --toc-indent-step: 0.5rem;
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
      article {
        margin-top: 1rem !important;
        padding-top: 1rem !important;
        margin-bottom: 1rem !important;
        padding-bottom: 1rem !important;
      }
      pre code {
        padding: 1em !important;
        font-size: 0.9rem;
      }
      code {
        padding: 0.1rem 0.2rem !important;
        font-size: 0.9em;
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

      /* Sidebar layout for posts */
      .post-layout {
        display: grid;
        grid-template-columns: minmax(0, 1fr) var(--toc-width);
        gap: 3rem;
        max-width: 1200px;
        margin: 0 auto;
        align-items: start;
      }

      .post-content {
        min-width: 0; /* Prevents grid overflow */
      }

      .post-sidebar {
        position: sticky;
        top: 2rem;
        width: var(--toc-width);
        max-height: calc(100vh - 3rem);
        overflow-y: auto;
        align-self: start;
      }

      .post-sidebar:empty {
        display: none;
      }

      .toc {
        padding: 0;
      }

      .toc h3 {
        margin: 0 0 0.75rem 0;
        font-size: 1rem;
        color: var(--color);
      }

      .toc ul {
        list-style: none;
        margin: 0;
        padding: 0;
      }

      .toc li {
        margin: 0;
        padding: 0;
      }

      .toc a {
        text-decoration: none;
        color: var(--muted-color);
        font-size: 0.875rem;
        line-height: 1.3;
        display: block;
        padding-top: 4px;
        padding-right: 1rem;
        padding-bottom: 4px;
        border-left: 1px solid var(--muted-border-color);
        transition: color 0.2s;
      }

      .toc a:hover {
        color: var(--primary);
      }

      .toc .toc-h2 {
        padding-left: var(--toc-indent-base);
      }

      .toc .toc-h3 {
        padding-left: calc(var(--toc-indent-base) + var(--toc-indent-step));
      }

      .toc .toc-h4 {
        padding-left: calc(var(--toc-indent-base) + (2 * var(--toc-indent-step)));
      }

      /* Responsive behavior */
      @media (max-width: 768px) {
        .post-layout {
          grid-template-columns: 1fr;
          gap: 1rem;
        }

        .post-sidebar {
          position: static;
          order: -1;
          width: auto;
          max-height: none;
        }

        .toc {
          margin-bottom: 1rem;
        }
      }

      /* Smooth scrolling */
      html {
        font-size: 15px;
        scroll-behavior: smooth;
      }

      /* Heading anchor styling */
      h2[id], h3[id], h4[id] {
        scroll-margin-top: 1rem;
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
      <a href="{$baseURL}archive.html"><i class="fas fa-box-archive"></i> Archive</a>
      <a href="{$baseURL}atom.xml"><i class="fas fa-rss"></i> Feed</a>
      <a href="https://github.com/silverjam/silverjam.github.io"><i class="fab fa-github"></i> GitHub</a>
    </nav>
  </header>
</xsl:template>

<xsl:template name="footer">
  <xsl:param name="baseURL" select="''" />
  <footer>
    <div class="social-links">
      <a href="https://github.com/silverjam" title="GitHub" aria-label="GitHub" rel="me">
        <i class="fab fa-github"></i>
      </a>
      <a href="https://hachyderm.io/@silverjam" title="Mastodon" aria-label="Mastodon" rel="me">
        <i class="fab fa-mastodon"></i>
      </a>
      <a href="https://www.threads.com/@silv3rjam" title="Threads" aria-label="Threads" rel="me">
        <i class="fa-brands fa-threads"></i>
      </a>
      <a href="https://www.instagram.com/silv3rjam/" title="Instagram" aria-label="Instagram" rel="me">
        <i class="fab fa-instagram"></i>
      </a>
      <a href="https://www.linkedin.com/in/silverjam" title="LinkedIn" aria-label="LinkedIn" rel="me">
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
      · <a href="{$baseURL}sitemap.xml">Sitemap</a>
    </div>
  </footer>
</xsl:template>

</xsl:stylesheet>

<!--
vim: ts=2:sts=2:sw=2:et:
-->
