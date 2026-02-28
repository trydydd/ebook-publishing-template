# Setup Guide

This guide will walk you through setting up your automated ebook publishing system.

## Prerequisites

- GitHub account
- Gumroad account (for automated publishing)
- Amazon KDP account (for manual publishing)
- Basic familiarity with Git and Markdown

## Step 1: Repository Setup

### 1.1 Create your repository from the template

To start a new book from this template (instead of forking or cloning this repo):

1. On GitHub, open this template repo and click **Use this template** → **Create a new repository**.
2. Name your new repo, create it, then either **clone** it to your machine or **open it on GitHub** and edit files in the browser (e.g. `templates/metadata.yml`, files in `chapters/`).

You now have your own copy to edit; the template repo stays unchanged.

### 1.2 Clone and configure (if working locally)

```bash
git clone https://github.com/yourusername/your-ebook-repo.git
cd your-ebook-repo

# Edit templates/metadata.yml with your book details
# Replace assets/cover.png with your cover image
```

## Step 2: Platform Setup

### 2.1 Gumroad Setup
1. Create a Gumroad account at https://gumroad.com
2. Create a new product (can be draft initially)
3. Go to Settings → Advanced → API
4. Generate an API access token
5. Note your product ID from the product URL

### 2.2 Amazon KDP Setup
1. Create an Amazon KDP account at https://kdp.amazon.com
2. Set up your tax information and payment details
3. Prepare your book metadata (title, description, keywords, etc.)

## Step 3: GitHub Configuration

### 3.1 Repository Secrets

To add secrets so GitHub Actions can access them (e.g. for Gumroad):

1. Open your repository on GitHub.
2. Click the **Settings** tab (top bar of the repo).
3. In the left sidebar, under "Security", click **Secrets and variables** → **Actions**.
4. Click **New repository secret**.
5. Add the first secret:
   - **Name:** `GUMROAD_ACCESS_TOKEN`  
   - **Value:** your Gumroad API token (from Gumroad: product → Settings → Advanced → API).
6. Click **New repository secret** again and add the second:
   - **Name:** `GUMROAD_PRODUCT_ID`  
   - **Value:** your Gumroad product ID. You can find this in the product URL on Gumroad: `https://gumroad.com/l/YourProductId` — the ID is the part after `/l/`.

### 3.2 Branch Protection (Recommended)
- Go to Settings → Branches
- Add rule for `main` branch
- Enable "Require pull request reviews before merging"

## Step 4: Content Creation

### 4.1 Book Metadata

Edit `templates/metadata.yml`. You can edit it in the GitHub web editor or in a text editor.

**Safe to edit** — Replace with your own:

- `title`, `subtitle`, `author`, `publisher`, `date` — Use double quotes: `title: "Your Book Title"`
- `version` — Used in the PDF filename (e.g. `my-book-v1.0.pdf`). Use something like `"1.0"`
- `description` — Keep the `|` on the line after `description:` so the next lines are treated as one block. You can use HTML like `<b>bold</b>` and `<br/>` for line breaks
- `language`, `subject`, `keywords`, `rights`, `isbn` — Optional; set as needed

**Leave as-is unless you know what you're doing** — The build and template depend on these:

- `cover-image: "assets/cover.png"` — Keep this path; put your cover file at `assets/cover.png` and replace that file
- `toc`, `toc-depth`, `number-sections`, `highlight-style` — Under "Technical Settings"
- `geometry`, `fontsize`, `linestretch`, `documentclass`, `papersize` — Under "PDF Settings"

**Minimal example:**

```yaml
title: "Your Book Title"
author: "Your Name"
date: "2025"
version: "1.0"
description: |
  One short paragraph about your book.
cover-image: "assets/cover.png"
```

**Common mistakes:**

- **Values with colons** — Put the value in quotes so YAML doesn’t treat the colon as a new key: `title: "My Book: A Guide"` not `title: My Book: A Guide`
- **Multiline description** — Use `description: |` and indent the following lines with two spaces; don’t forget the `|`
- **Wrong indentation** — YAML uses spaces, not tabs. Keep key-value pairs at the same indent level

### 4.2 Chapter Structure
- Name chapters with numbers: `01-introduction.md`, `02-chapter-one.md`
- Use consistent markdown formatting
- Place images in `assets/images/`

### 4.3 Cover Image
- Replace `assets/cover.png` with your cover
- Recommended size: 1600x2400 pixels
- Format: PNG or JPG

## Step 5: Testing

### 5.1 Local Testing

Before pushing, run the same checker that CI runs to catch missing cover or metadata:

```bash
python scripts/validate.py
```

Run from the repo root. If validation passes, build the PDF (Docker or host):

```bash
# With Docker (recommended)
docker compose build && docker compose up

# Or on host if you have Pandoc/LaTeX
chmod +x scripts/build.sh
./scripts/build.sh
```

Your PDFs will appear in the **`output/`** folder: `your-title-v1.0.pdf`, `your-title-v1.0-kdp.pdf`, and `your-title-v1.0-mobile.pdf` (names come from `title` and `version` in `templates/metadata.yml`). Open the `output/` folder in Finder or File Explorer to view them.

### 5.2 First Deployment
```bash
git add .
git commit -m "Initial book setup"
git push origin main
```

Check the Actions tab for build status.

## Step 6: Publishing Workflow

### 6.1 Writing Process
1. Create/edit chapters in `chapters/` directory
2. Commit changes to a feature branch
3. Create pull request for review
4. Merge to main triggers automatic build

### 6.2 Gumroad Publishing
- Automatic when you push to main
- Check build logs for any errors
- Verify update on Gumroad dashboard

### 6.3 Amazon KDP Publishing
1. Download PDF from GitHub Releases
2. Log into KDP dashboard
3. Upload new version manually
4. Update metadata if needed

## Troubleshooting

### Common Issues

**Build script errors** — If the build fails with one of these messages, try the fix listed:

| Build error | What to do |
|-------------|------------|
| No markdown files found in chapters/ directory | Add at least one chapter file in `chapters/`, e.g. `01-introduction.md`. Use the `NN-name.md` naming pattern. |
| Combined markdown file is empty | Your chapter `.md` files may be empty or unreadable. Ensure each file in `chapters/` has content and is valid Markdown. |
| Metadata file not found | Ensure `templates/metadata.yml` exists. If you renamed or moved it, restore it or update the build script. |
| PDF generation failed | Pandoc or LaTeX failed. Check the full build log (e.g. in GitHub Actions or Docker output) for the real error—often a missing image path, bad LaTeX, or invalid Markdown. |

**Build fails with LaTeX errors:**
- Check your markdown syntax
- Ensure all referenced images exist
- Review the build logs in GitHub Actions

**Gumroad upload fails:**
- Verify your API token is correct
- Check product ID matches your Gumroad product
- Ensure product exists and is accessible

**PDF formatting issues:**
- Adjust settings in `templates/pandoc-template.tex`
- Modify build parameters in `scripts/build.sh`

### Getting Help

1. See the Common Issues section above in this guide
2. Review GitHub Actions logs
3. Open an issue with:
   - Error messages
   - Build logs
   - Steps to reproduce

## Advanced Configuration

### Custom Styling
- Edit `templates/pandoc-template.tex` for LaTeX styling
- Modify `templates/styles.css` for HTML output
- Add custom fonts to `assets/fonts/`

### Multiple Formats
The system can be extended to generate:
- EPUB files
- HTML versions
- Different PDF sizes

See the build script for extension points.
