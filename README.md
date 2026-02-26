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

## Quick Start

1. **Edit the metadata:**
   - Update `templates/metadata.yml` with your book information
   - Replace `assets/cover.png` with your book cover

2. **Write your chapters:**
   - Edit files in the `chapters/` directory
   - Follow the naming convention: `01-chapter-name.md`

3. **Set up GitHub Secrets:**
   - `GUMROAD_ACCESS_TOKEN`: Your Gumroad API token
   - `GUMROAD_PRODUCT_ID`: Your Gumroad product ID

4. **Push to main branch:**
   ```bash
   git add .
   git commit -m "Initial book setup"
   git push origin main
   ```

5. **Check GitHub Actions tab** for build status

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

This will generate your PDFs in the `output/` directory (standard, KDP, and mobile versions).

### Requirements
- Docker and Docker Compose installed on your system.

---

You can also run the build script directly on your host if you have all dependencies installed:

```bash
bash scripts/build.sh
```

See the `Dockerfile` and `docker-compose.yml` for details on the build environment.

## Documentation

- [Setup Guide](SETUP.md) - Detailed setup instructions
- [Contributing](docs/CONTRIBUTING.md) - How to contribute
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [API Documentation](docs/API.md) - Platform API details

## Example Book

This repository includes a sample book about the automated publishing process itself. You can use it as a template or replace it with your own content.

## Support

If you encounter issues:
1. Check the [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
2. Review the [GitHub Actions logs](../../actions)
3. Open an issue with details about your problem

## License

MIT License - see [LICENSE](LICENSE) for details.
