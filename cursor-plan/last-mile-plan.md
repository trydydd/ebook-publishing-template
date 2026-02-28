# Last-Mile Plan: User Experience and Standards

This plan covers the remaining work to make the ebook template easy for non-technical users and to document standards so builds stay reliable (e.g. image sizes, formats).

---

## 1. Make the project more user-friendly (non-technical users)

- **Goal:** Someone with little or no Git/terminal experience can set up the repo, edit content, and get PDFs (locally or via GitHub) without getting stuck.
- **Out of scope (for this plan):** Changing the build pipeline (Pandoc/LaTeX) or adding a GUI editor.

**Subtasks:**

1. ~~**Fix or remove broken doc links**~~ *(Done)* — Either add the missing docs under `docs/` (at least CONTRIBUTING, TROUBLESHOOTING, API or a single “Help” doc) or remove/rewrite the links in README and SETUP so nothing 404s.
2. ~~**Add a “Choose your path” section to README**~~ *(Done)* — Short, scannable paths: “I’ll edit in GitHub’s web editor,” “I’ll build PDFs locally with Docker,” “I’m ready to deploy to Gumroad.” Each path with 3–5 steps and the next doc to open (e.g. SETUP for secrets, Troubleshooting for failures).
3. ~~**Document GitHub Secrets with exact navigation**~~ *(Done)* — In SETUP (and optionally README): step-by-step: Repository → **Settings** (tab) → **Secrets and variables** → **Actions** → **New repository secret**. Name and add `GUMROAD_ACCESS_TOKEN`, then same for `GUMROAD_PRODUCT_ID`. Optional: one short “Where to find your Gumroad product ID” sentence.
4. ~~**Expose "validate before push"**~~ *(Done)* — In README and SETUP; validation runs in Docker before build.
5. ~~**Add a minimal "Editing metadata" guide**~~ *(Done)* — In SETUP or a short `docs/EDITING.md`: which fields are safe to edit, which to leave as-is, minimal example, common mistakes.
6. ~~**Document "Use this template" for new books**~~ *(Done)* — In README and SETUP.
7. ~~**Map build errors to help**~~ *(Done)* — Build-error table in SETUP.md Common Issues; build.sh points to SETUP.md#troubleshooting.
8. ~~**Make the output folder obvious**~~ *(Done)* — README and SETUP point to output/ with filenames; mention Finder/Explorer.

---

## 2. Document standards to avoid bugs

- **Goal:** Clear, single-place guidance on assets and content so builds don’t fail and outputs look correct (e.g. no broken images, wrong aspect ratios, or invalid metadata).
- **Relevant today:** Cover image (`assets/cover.png`), chapter images (`assets/images/`), metadata (`templates/metadata.yml`), and chapter naming/conventions.

**Subtasks:**

1. **Create a single standards doc** — Add a canonical reference (e.g. `docs/STANDARDS.md` or `docs/ASSETS_AND_CONTENT.md`) that links from README and SETUP. All asset and content rules live here so there’s one place to check and update.
2. **Document cover image standards** — In the standards doc: path (`assets/cover.png`), recommended dimensions (e.g. 1600×2400 px) and why (aspect ratio with `0.95\textheight` in the template), allowed formats (PNG, JPEG), and that the path in `metadata.yml` must match the file (e.g. `cover-image: "assets/cover.png"`).
3. **Document chapter/interior image standards** — Where to put files (`assets/images/`), how to reference them in Markdown (e.g. `![](images/filename.png)` given `--resource-path=.:assets:assets/images`), recommended formats (PNG, JPEG; note SVG/other if supported), and optional max dimensions or DPI guidance to avoid huge PDFs or slow builds.
4. **Document chapter file naming and order** — Naming convention (e.g. `01-title.md`, `02-title.md` with zero-padded numbers), that order is determined by filename via `sort -V`, and that duplicate or non-numeric prefixes can produce unexpected order.
5. **Document metadata standards** — Required fields (title, author, date, description; and `version` for the build, even though the validator doesn’t check it yet), optional fields, `cover-image` path rules, and YAML gotchas (quotes around values with colons, multiline `description` with `|`). Optionally note which fields are passed to PDF (e.g. subject, keywords) or Gumroad.
6. **Document custom fonts (if applicable)** — Path (`assets/fonts/`), filenames expected by the template (e.g. EBGaramond-Regular.ttf, etc.), and license (OFL) so users don’t ship fonts that conflict with distribution.
7. **Align validation with standards** — Ensure `scripts/validate.py` checks anything that’s required for a successful build (e.g. `version` in metadata, cover file exists). Document in the standards doc that running `validate.py` before push catches common violations; list any rules that are “documented only” (e.g. image dimensions) and not enforced by the script.
8. **Document supported Markdown elements** — In the standards doc (or a dedicated “Markdown guide” section), list only the Markdown features that appear in the existing chapter files and are therefore known to work in the built PDF. Include: ATX-style headers (`#`, `##`, `###`), **bold** and *italic*, unordered lists (`*` or `-`), ordered lists (`1. 2. 3.`), fenced divs for sidebars (`::: {.sidebar title="Title"} ... :::` per [scripts/sidebar.lua](scripts/sidebar.lua)), and horizontal rules (`---`). Do not document or recommend elements that are not present in the chapters (e.g. code blocks, inline code, images, links)—those have not been tested.

---

## Reference (current state)

- **Build:** [scripts/build.sh](scripts/build.sh) (Docker or host); [README.md](README.md) and [SETUP.md](SETUP.md) for setup.
- **Assets:** `assets/cover.png`, `assets/images/` (resource path in build), `assets/fonts/`.
- **Content:** `chapters/*.md` (natural sort), `templates/metadata.yml`, `templates/pandoc-template.tex`.
- **Docs:** README points to `docs/CONTRIBUTING.md`, `docs/TROUBLESHOOTING.md`, `docs/API.md`; those files may need to be created or linked from this plan.
