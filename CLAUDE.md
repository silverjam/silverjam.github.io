# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static blog generator that transforms Markdown posts into HTML using a unique XSLT-based pipeline. The build system converts Markdown → XML → HTML through comrak and Saxon XSLT processor, creating a blog with consistent styling via Pico.css and highlight.js syntax highlighting.

## Build Commands

### Primary Commands
- `make all` - Complete build: markdown to XML, XML to HTML, generate index page
- `make install-deps` - Install comrak v0.41.1 and saxonb-xslt dependencies
- `make html` - Generate HTML files from existing XML files
- `make xml` - Convert markdown posts to XML (intermediate format)
- `make test-render` - Test rendering of single post (2023-07-24.markdown)
- `make snapshot` - Create PNG screenshots of all pages using Docker + Chromium

### Dependency Management
- `comrak --version` should show v0.41.1 (critical version requirement)
- Dependencies: `cargo install comrak --version "0.41.1"`, `sudo apt-get install -y libsaxonb-java default-jre`
- Optional: Docker (required for `make snapshot` to create page screenshots)

## Architecture

### Build Pipeline
1. **Markdown → XML**: `comrak --front-matter-delimiter="---" --gfm -t xml` converts posts from `_posts/` to `_build/`
2. **XML → HTML**: `saxonb-xslt` applies XSL templates from `xsl/` to generate final HTML in `posts/`
3. **Index Generation**: Processes all XML files to create main index.html page

### Directory Structure
- `_posts/` - Markdown source files (YYYY-MM-DD-title.markdown format)
- `_build/` - Intermediate XML files + CommonMark.dtd symlink
- `posts/` - Generated HTML files
- `xsl/` - XSLT templates (head.xsl, post.xsl, index.xsl)
- `.CommonMark.dtd` - Hidden DTD file for XML validation (auto-downloaded)

### XSL Template Hierarchy
- `head.xsl` - Common HTML head template with Pico.css + highlight.js
- `post.xsl` - Individual post transformation (imports head.xsl)
- `index.xsl` - Blog index page generation (imports head.xsl)

## Adding New Blog Posts

### Process
1. Create `_posts/YYYY-MM-DD-title.markdown` file
2. Add frontmatter and metadata table (see existing posts for format)
3. **Critical**: Add new file to `POSTS_MD` variable in Makefile
4. Run `make all` to regenerate site

### Post Structure
```markdown
---
some_frontmatter: "value"
---

# Post Title

| Metadata   | Value            |
| ---------- | ---------------- |
| Date       | YYYY-MM-DD       |
| Categories | tag1, tag2, tag3 |

---

*SUMMARY: Brief post summary goes here.*

## Content sections...
```

## Development Notes

### CommonMark DTD
- `.CommonMark.dtd` file automatically downloaded via curl from official CommonMark spec repository
- Auto-fetched via `curl -sSLo .CommonMark.dtd https://raw.githubusercontent.com/commonmark/commonmark-spec/refs/heads/master/CommonMark.dtd` in Makefile
- Provides XML validation for markdown conversion
- Hidden file (dotfile) to keep directory listing clean

### Styling Customization
- Modify `xsl/head.xsl` for global styles, CSS CDN links, or JavaScript
- Edit `xsl/post.xsl` or `xsl/index.xsl` for layout changes
- Uses Pico.css classless framework + custom overrides

### Build System
- Makefile handles all transformations with proper dependency tracking
- Parallel builds supported for multiple posts
- `COMRAK_VERSION` variable enforces exact version requirement
- Incremental builds only regenerate changed posts