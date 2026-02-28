# Ebook Template

An automated system for publishing ebooks from markdown files to PDF format, with deployment to Gumroad and Amazon KDP.

## Features

- ✅ Write in Markdown with version control
- ✅ Automatic PDF generation with professional formatting
- ✅ Auto-deploy to Gumroad
- ✅ KDP-optimized PDF generation
- ✅ Mobile-optimized PDF generation
- ✅ Multiple format support (PDF, EPUB coming soon)
- ✅ Automated table of contents
- ✅ Custom styling and templates
- ✅ CI/CD with GitHub Actions

**Starting a new book?** Click **Use this template** → **Create a new repository** on GitHub to create your own copy. You then edit that repo (in the browser or after cloning). You don't need to fork or clone this template repo directly.

## Choose your path

**I'll edit in GitHub's web editor.**  
1. Use **Use this template** → **Create a new repository** to make your own copy.  
2. Open your repo on GitHub and edit `templates/metadata.yml` and files in `chapters/` in the browser.  
3. Commit your changes. To get PDFs, push to `main` so GitHub Actions runs the build.  
4. Next: [Setup Guide](SETUP.md) for GitHub Secrets (if you use Gumroad) and more detail.

**I'll build PDFs locally with Docker.**  
1. Clone this repo (or your copy from the template).  
2. Run `docker compose build`, then `docker compose up`.  
3. Find your PDFs in the `output/` folder.  
4. Next: [Setup Guide](SETUP.md) for metadata and cover image; see **Building the Ebook Locally with Docker** below for requirements.

**I'm ready to deploy (e.g. to Gumroad).**  
1. Finish your content and metadata; run a local build or push to `main` to confirm the build succeeds.  
2. In your repo: **Settings** → **Secrets and variables** → **Actions**; add `GUMROAD_ACCESS_TOKEN` and `GUMROAD_PRODUCT_ID` if you use Gumroad.  
3. Push to `main` to trigger build and release.  
4. Next: [Setup Guide](SETUP.md) for platform setup; if something fails, see the Troubleshooting section there.

## Quick Start

1. **Edit the metadata:**
   - Update `templates/metadata.yml` with your book information
   - Replace `assets/cover.png` with your book cover

2. **Write your chapters:**
   - Edit files in the `chapters/` directory
   - Follow the naming convention: `01-chapter-name.md`

3. **Set up GitHub Secrets** (if you use Gumroad): add `GUMROAD_ACCESS_TOKEN` and `GUMROAD_PRODUCT_ID` in the repo: **Settings** → **Secrets and variables** → **Actions** → **New repository secret**. See [Setup Guide](SETUP.md) for step-by-step and where to find your Gumroad product ID.

4. **Before pushing,** run the checker to catch missing cover or metadata (same as in CI):
   ```bash
   python scripts/validate.py
   ```
   Run this from the repo root. If it fails, fix the reported issues before pushing.

5. **Push to main branch:**
   ```bash
   git add .
   git commit -m "Initial book setup"
   git push origin main
   ```

6. **Check GitHub Actions tab** for build status

## Building the Ebook Locally with Docker

You can build the PDF locally in a reproducible environment using Docker. This ensures you don't need to install Pandoc, LaTeX, or Python dependencies on your host system.

### Steps

1. **Build the Docker image:**
   ```bash
   docker compose build
   ```

2. **Run the build process:**
   ```bash
   docker compose up
   ```

Your PDFs appear in the **`output/`** folder: `your-title-v1.0.pdf` (standard), `your-title-v1.0-kdp.pdf`, and `your-title-v1.0-mobile.pdf` (the exact names depend on your `title` and `version` in `templates/metadata.yml`). Open the `output/` folder in Finder or File Explorer to view them.

### Requirements
- Docker and Docker Compose installed on your system.

---

You can also run the build script directly on your host if you have all dependencies installed:

```bash
bash scripts/build.sh
```

PDFs are written to **`output/`** (same filenames as above). See the `Dockerfile` and `docker-compose.yml` for details on the build environment.

## Documentation

- [Setup Guide](SETUP.md) - Detailed setup instructions

## Example Book

This repository includes a sample book about the automated publishing process itself. You can use it as a template or replace it with your own content.

## Support

If you encounter issues:
1. Check the Troubleshooting section in [SETUP.md](SETUP.md)
2. Review the [GitHub Actions logs](../../actions)
3. Open an issue with details about your problem

## License

MIT License - see [LICENSE](LICENSE) for details.
