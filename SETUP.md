# Setup Guide

This guide will walk you through setting up your automated ebook publishing system.

## Prerequisites

- GitHub account
- Gumroad account (for automated publishing)
- Amazon KDP account (for manual publishing)
- Basic familiarity with Git and Markdown

## Step 1: Repository Setup

### 1.1 Clone and Configure
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
Go to your repository → Settings → Secrets and Variables → Actions

Add these secrets:
- `GUMROAD_ACCESS_TOKEN`: Your Gumroad API token
- `GUMROAD_PRODUCT_ID`: Your Gumroad product ID

### 3.2 Branch Protection (Recommended)
- Go to Settings → Branches
- Add rule for `main` branch
- Enable "Require pull request reviews before merging"

## Step 4: Content Creation

### 4.1 Book Metadata
Edit `templates/metadata.yml`:
```yaml
title: "Your Book Title"
author: "Your Name"
publisher: "Your Publisher"
date: "2024"
description: |
  Your book description here.
  Can be multiple lines.
language: en-US
subject: "Your Category"
cover-image: "assets/cover.png"
```

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
```bash
# Install dependencies (requires Docker or native LaTeX)
chmod +x scripts/build.sh
./scripts/build.sh

# Check output/book.pdf
```

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

1. Check [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
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
