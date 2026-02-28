#!/usr/bin/env python3
"""
Content validation script for ebook publishing
"""

import subprocess
import sys
import yaml
from pathlib import Path
from typing import List, Tuple

def validate_metadata() -> Tuple[bool, List[str]]:
    """Validate metadata.yml file"""
    errors = []
    
    metadata_path = Path('templates/metadata.yml')
    if not metadata_path.exists():
        errors.append("Metadata file not found: templates/metadata.yml")
        return False, errors
    
    try:
        with open(metadata_path, 'r') as f:
            metadata = yaml.safe_load(f)
        
        # Required fields (version is required by build.sh for PDF basename)
        required_fields = ['title', 'author', 'date', 'description', 'version']
        for field in required_fields:
            if not metadata.get(field):
                errors.append(f"Missing required metadata field: {field}")
        
        # Validate cover image
        cover_path = metadata.get('cover-image')
        if cover_path and not Path(cover_path).exists():
            errors.append(f"Cover image not found: {cover_path}")
        
        print(f"✅ Metadata validation passed")
        return len(errors) == 0, errors
        
    except yaml.YAMLError as e:
        errors.append(f"Invalid YAML in metadata file: {e}")
        return False, errors

def validate_chapters() -> Tuple[bool, List[str]]:
    """Validate chapter files exist and contain valid markdown."""
    errors = []
    chapters_dir = Path('chapters')

    if not chapters_dir.exists():
        errors.append("Chapters directory not found")
        return False, errors

    md_files = sorted(chapters_dir.glob('*.md'))
    if not md_files:
        errors.append("No markdown files found in chapters directory")
        return False, errors

    # Validate each file with pandoc (same engine used for the build)
    for path in md_files:
        try:
            result = subprocess.run(
                ["pandoc", "-f", "markdown", "-t", "json", str(path)],
                capture_output=True,
                text=True,
                timeout=10,
            )
        except FileNotFoundError:
            errors.append(
                "Pandoc not found; cannot validate markdown. "
                "Install pandoc or run validation in Docker."
            )
            return False, errors
        except subprocess.TimeoutExpired:
            errors.append(f"Markdown validation timed out: {path.name}")
            continue
        if result.returncode != 0:
            msg = (result.stderr or result.stdout or "unknown error").strip()
            errors.append(f"Invalid markdown in {path}: {msg}")

    if errors:
        return False, errors
    print(f"✅ Validated {len(md_files)} chapters")
    return True, errors

def main():
    """Main validation function"""
    print("🔍 Validating ebook content...")
    
    all_valid = True
    all_errors = []
    
    # Validate metadata
    valid, errors = validate_metadata()
    if not valid:
        all_valid = False
        all_errors.extend(errors)
    
    # Validate chapters
    valid, errors = validate_chapters()
    if not valid:
        all_valid = False
        all_errors.extend(errors)
    
    if all_valid:
        print("✅ All validations passed!")
        sys.exit(0)
    else:
        print("❌ Validation failed:")
        for error in all_errors:
            print(f"  - {error}")
        sys.exit(1)

if __name__ == "__main__":
    main()
