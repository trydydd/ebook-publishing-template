# Ebook template standards

This document is the single reference for asset and content rules so builds succeed and PDFs look correct. Follow these standards to avoid broken images, wrong aspect ratios, and invalid metadata.

Run `python scripts/validate.py` from the repo root before pushing to catch many violations. Some rules are enforced by the validator; others are documented here only (e.g. image dimensions).

---

## Cover image

- **Path:** `assets/cover.png`  
  The build and template expect the cover at this path. Put your file there and replace the placeholder; keep the path in metadata as below.

- **In metadata:** In `templates/metadata.yml`, set `cover-image: "assets/cover.png"`. The value must match the actual file location.

- **Recommended dimensions:** 1600×2400 pixels (or similar portrait ratio). The template uses `0.95\textheight` with `keepaspectratio`, so a portrait aspect ratio looks best.

- **Formats:** PNG or JPEG.

---

## Chapter / interior images

- **Where to put files:** `assets/images/`  
  The build uses `--resource-path=.:assets:assets/images`, so Pandoc looks in the repo root, `assets/`, and `assets/images/`.

- **How to reference in Markdown:** Use a path that resolves from those roots, e.g. `![](images/filename.png)` (from `assets/images/filename.png`).

- **Formats:** PNG or JPEG are safe. SVG or other formats may work but are not verified in this template.

- **Size:** Very large images can make PDFs big or slow. Prefer reasonable dimensions (e.g. under ~2000 px on the long side) and avoid embedding huge originals. In-chapter image usage is not yet exercised in the sample chapters; add images and run a build to confirm.

---

## Chapter files: naming and order

- **Naming:** Use zero-padded numbers and a slug, e.g. `01-introduction.md`, `02-goals.md`, `10-appendix.md`.

- **Order:** Chapter order is determined by **filename** via `sort -V` (version sort). So `01-a.md` comes before `02-b.md`; `2-foo.md` would sort after `10-bar.md` if you mix digit lengths, so stick to zero-padded numbers.

- **Avoid:** Duplicate numeric prefixes or non-numeric prefixes can produce unexpected order. Keep one `.md` per chapter and use the `NN-name.md` pattern.

---

## Metadata (`templates/metadata.yml`)

- **Required for the build:**  
  `title`, `author`, `date`, `description`, and `version`.  
  The validator checks `title`, `author`, `date`, `description`; the build script also requires `version` (used in the PDF filename). All five are required for a successful build.

- **Optional but common:**  
  `subtitle`, `publisher`, `language`, `subject`, `keywords`, `rights`, `isbn`, `cover-image`, and the technical/PDF settings (`toc`, `toc-depth`, `number-sections`, `highlight-style`, `geometry`, `fontsize`, etc.).

- **Cover image:**  
  Set `cover-image: "assets/cover.png"` and ensure that file exists (see Cover image above).

- **YAML gotchas:**  
  - Put values that contain colons in quotes: `title: "My Book: A Guide"`.  
  - Multiline `description`: use `description: |` and indent the following lines with two spaces; the `|` keeps line breaks.  
  - Use spaces for indentation, not tabs.

- **Passed to PDF:**  
  Fields such as `title`, `author`, `date`, `subject`, `keywords` are used in the PDF (e.g. metadata, headings). The template and build script use the keys defined in `metadata.yml`.

---

## Custom fonts

- **Path:** `assets/fonts/`  
  The Pandoc/LaTeX template expects custom fonts in this directory.

- **Filenames expected by the template:**  
  The default template uses EBGaramond:  
  `EBGaramond-Regular.ttf`, `EBGaramond-Bold.ttf`, `EBGaramond-Italic.ttf`, `EBGaramond-BoldItalic.ttf`  
  If you change fonts, update `templates/pandoc-template.tex` to match.

- **License:**  
  Use fonts that allow embedding and distribution (e.g. OFL). Don’t ship fonts that prohibit use in PDFs.

---

## Validation vs. documented-only rules

Running `python scripts/validate.py` (from the repo root) checks:

- `templates/metadata.yml` exists and is valid YAML  
- Required metadata fields: `title`, `author`, `date`, `description`, `version`  
- Cover image exists when `cover-image` is set  
- `chapters/` exists and contains at least one `.md` file  
- Each chapter file is valid Markdown (via Pandoc)

**Documented only (not enforced by the script):**  
Cover image dimensions (1600×2400 recommended), interior image size, exact chapter naming pattern, and font licensing. Follow the standards in this doc to avoid layout or legal issues.

---

## Supported Markdown (verified in this template)

Only the following Markdown features are used in the sample chapters and are known to work in the built PDF. Stick to these to avoid surprises.

- **ATX-style headers:** `#`, `##`, `###` for chapter and section titles.

- **Bold and italic:** `**bold**`, `*italic*`.

- **Unordered lists:** `*` or `-` for bullet lists.

- **Ordered lists:** `1.`, `2.`, `3.` for numbered lists. You can combine with bold, e.g. `1. **Item** – text`.

- **Sidebars (callout boxes):** Fenced div with class `sidebar` and a `title` attribute:
  ```markdown
  ::: {.sidebar title="Your Title"}
  Content here.
  :::
  ```
  This is handled by `scripts/sidebar.lua` and rendered as a styled box in the PDF.

- **Horizontal rule:** `---` on its own line (e.g. to separate sections or end a chapter).

Do **not** rely on other features (e.g. code blocks, inline code, images, links) unless you’ve tested them in this template; they are not used in the sample chapters and may not render as expected.
