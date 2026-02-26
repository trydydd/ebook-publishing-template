#!/usr/bin/env bash

set -eu

# Extract title and version from metadata.yml (no yq required)
TITLE=$(grep '^title:' templates/metadata.yml | sed 's/title:[ ]*//;s/^"\(.*\)"$/\1/' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
VERSION=$(grep '^version:' templates/metadata.yml | sed 's/version:[ ]*//;s/^"\(.*\)"$/\1/')
BASENAME="${TITLE}-v${VERSION}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

error_exit() {
    log "❌ Error: $1"
    exit "$2"
}

log "🚀 Starting ebook build process..."

# Create output directory and ensure it's writable
mkdir -p output
chmod -R a+rw output

# Validate chapters exist
if [ ! -d "chapters" ] || [ -z "$(ls -A chapters/*.md 2>/dev/null)" ]; then
    error_exit "No markdown files found in chapters/ directory" 10
fi

# Combine all top-level markdown files in order (natural sort), inserting a new line between each for Pandoc
log "📚 Combining chapters with explicit chapter breaks..."
first=1
for file in $(ls chapters/*.md | sort -V); do
    if [ $first -eq 0 ]; then
        echo -e "\n" >> output/combined.md
    fi
    cat "$file" >> output/combined.md
    first=0
done

# Check if combined file has content
if [ ! -s "output/combined.md" ]; then
    error_exit "Combined markdown file is empty" 11
fi

# Validate metadata file
if [ ! -f "templates/metadata.yml" ]; then
    error_exit "Metadata file not found" 12
fi

# Common Pandoc options
PANDOC_COMMON_OPTS="--metadata-file=templates/metadata.yml \
  --template=templates/pandoc-template.tex \
  --pdf-engine=xelatex \
  --toc \
  --toc-depth=2 \
  --number-sections \
  --highlight-style=tango \
  --top-level-division=chapter \
  --resource-path=.:assets:assets/images"

log "📖 Converting to PDF (Standard version)..."
pandoc output/combined.md \
  $PANDOC_COMMON_OPTS \
  --lua-filter=scripts/sidebar.lua \
  -V geometry:margin=1in \
  -V fontsize=12pt \
  -V linestretch=1.0 \
  -V documentclass=book \
  -V papersize=a5 \
  -o output/$BASENAME.pdf \
  --verbose

log "📱 Creating KDP-optimized version..."
pandoc output/combined.md \
  $PANDOC_COMMON_OPTS \
  --lua-filter=scripts/sidebar.lua \
  -V geometry:margin=0.75in \
  -V fontsize=10pt \
  -V linestretch=1.15 \
  -V documentclass=book \
  -V papersize=letter \
  -o output/$BASENAME-kdp.pdf \
  --verbose

log "📱 Creating mobile-optimized version..."
pandoc output/combined.md \
  $PANDOC_COMMON_OPTS \
  --lua-filter=scripts/sidebar.lua \
  -V geometry:margin=0.25in \
  -V fontsize=12pt \
  -V linestretch=1.0 \
  -V documentclass=book \
  -V papersize=a6 \
  -o output/$BASENAME-mobile.pdf \
  --verbose

# Verify PDFs were created
if [ -f "output/$BASENAME.pdf" ] && [ -f "output/$BASENAME-kdp.pdf" ] && [ -f "output/$BASENAME-mobile.pdf" ]; then
    log "✅ Build complete!"
    log "📄 Standard PDF: $(ls -lh output/$BASENAME.pdf | awk '{print $5}')"
    log "📄 KDP PDF: $(ls -lh output/$BASENAME-kdp.pdf | awk '{print $5}')"
    log "📄 Mobile PDF: $(ls -lh output/$BASENAME-mobile.pdf | awk '{print $5}')"
    # Ensure generated PDFs are writable so they can be removed without sudo
    chmod a+rw output/$BASENAME.pdf output/$BASENAME-kdp.pdf output/$BASENAME-mobile.pdf
else
    error_exit "PDF generation failed" 13
fi

# Clean up temporary files
rm -f output/combined.md

log "🎉 Ebook build successful!"