#!/usr/bin/env bash
#
# convert.sh - Pandoc wrapper for markdown ↔ DOCX conversion
#
# Usage:
#   ./convert.sh md2docx <input.md> [output.docx]
#   ./convert.sh docx2md <input.docx> [output.md]
#
# Description:
#   Converts between markdown and DOCX formats while preserving:
#   - Document structure and headings
#   - Code blocks and syntax highlighting
#   - Tables and lists
#   - Metadata (YAML frontmatter)
#
# Requirements:
#   - pandoc (install: brew install pandoc)
#
# Examples:
#   # Convert markdown to DOCX
#   ./convert.sh md2docx docs/specs/feature.md
#   ./convert.sh md2docx docs/specs/feature.md output/feature.docx
#
#   # Convert DOCX to markdown
#   ./convert.sh docx2md external-spec.docx
#   ./convert.sh docx2md external-spec.docx docs/specs/imported-spec.md
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check if pandoc is installed
check_pandoc() {
    if ! command -v pandoc &> /dev/null; then
        log_error "pandoc is not installed"
        log_info "Install with: brew install pandoc"
        exit 1
    fi

    local version
    version=$(pandoc --version | head -n1)
    log_info "Using $version"
}

# Show usage
usage() {
    cat << EOF
Usage: $0 <command> <input> [output]

Commands:
  md2docx     Convert markdown to DOCX
  docx2md     Convert DOCX to markdown

Arguments:
  input       Input file path (required)
  output      Output file path (optional, auto-generated if not provided)

Examples:
  # Markdown to DOCX
  $0 md2docx docs/specs/LIN-123-feature.md
  $0 md2docx docs/specs/LIN-123-feature.md output/feature.docx

  # DOCX to Markdown
  $0 docx2md external-spec.docx
  $0 docx2md external-spec.docx docs/specs/imported-spec.md

Options:
  -h, --help  Show this help message

Requirements:
  - pandoc must be installed (brew install pandoc)
EOF
}

# Generate output filename based on input
generate_output_filename() {
    local input="$1"
    local command="$2"
    local basename
    local extension

    basename=$(basename "$input")

    case "$command" in
        md2docx)
            extension=".docx"
            echo "${basename%.md}${extension}"
            ;;
        docx2md)
            extension=".md"
            echo "${basename%.docx}${extension}"
            ;;
        *)
            log_error "Unknown command: $command"
            exit 1
            ;;
    esac
}

# Convert markdown to DOCX
md2docx() {
    local input="$1"
    local output="$2"

    log_info "Converting markdown to DOCX"
    log_info "Input:  $input"
    log_info "Output: $output"

    # Check if input file exists
    if [[ ! -f "$input" ]]; then
        log_error "Input file not found: $input"
        exit 1
    fi

    # Create output directory if it doesn't exist
    local output_dir
    output_dir=$(dirname "$output")
    if [[ ! -d "$output_dir" ]]; then
        mkdir -p "$output_dir"
        log_info "Created output directory: $output_dir"
    fi

    # Run pandoc conversion
    pandoc "$input" \
        --from markdown+yaml_metadata_block \
        --to docx \
        --output "$output" \
        --standalone \
        --toc \
        --highlight-style tango \
        --reference-doc="${SCRIPT_DIR}/reference.docx" 2>/dev/null || \
    pandoc "$input" \
        --from markdown+yaml_metadata_block \
        --to docx \
        --output "$output" \
        --standalone \
        --toc \
        --highlight-style tango

    if [[ $? -eq 0 ]]; then
        log_success "Conversion complete"
        log_success "Output saved to: $output"

        # Show file size
        if command -v du &> /dev/null; then
            local size
            size=$(du -h "$output" | cut -f1)
            log_info "File size: $size"
        fi
    else
        log_error "Conversion failed"
        exit 1
    fi
}

# Convert DOCX to markdown
docx2md() {
    local input="$1"
    local output="$2"

    log_info "Converting DOCX to markdown"
    log_info "Input:  $input"
    log_info "Output: $output"

    # Check if input file exists
    if [[ ! -f "$input" ]]; then
        log_error "Input file not found: $input"
        exit 1
    fi

    # Create output directory if it doesn't exist
    local output_dir
    output_dir=$(dirname "$output")
    if [[ ! -d "$output_dir" ]]; then
        mkdir -p "$output_dir"
        log_info "Created output directory: $output_dir"
    fi

    # Run pandoc conversion
    pandoc "$input" \
        --from docx \
        --to markdown+yaml_metadata_block \
        --output "$output" \
        --standalone \
        --extract-media="${output_dir}/media" \
        --wrap=none

    if [[ $? -eq 0 ]]; then
        log_success "Conversion complete"
        log_success "Output saved to: $output"

        # Add default YAML frontmatter if missing
        if ! grep -q "^---$" "$output"; then
            log_info "Adding default YAML frontmatter"
            local temp_file="${output}.tmp"
            cat > "$temp_file" << 'FRONTMATTER'
---
title: [Document Title]
linear_id: LIN-XXX
type: [spec|adr|runbook]
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: [Your Name]
related: []
---

FRONTMATTER
            cat "$output" >> "$temp_file"
            mv "$temp_file" "$output"
            log_warning "Please update the YAML frontmatter with actual values"
        fi

        # Show file size
        if command -v wc &> /dev/null; then
            local lines
            lines=$(wc -l < "$output" | tr -d ' ')
            log_info "Lines: $lines"
        fi
    else
        log_error "Conversion failed"
        exit 1
    fi
}

# Batch conversion
batch_convert() {
    local command="$1"
    local pattern="$2"
    local output_dir="$3"

    log_info "Batch converting files matching: $pattern"

    local count=0
    local failed=0

    for file in $pattern; do
        if [[ -f "$file" ]]; then
            local output
            output="$output_dir/$(generate_output_filename "$file" "$command")"

            log_info "Processing: $file"

            if "$command" "$file" "$output"; then
                ((count++))
            else
                ((failed++))
                log_error "Failed to convert: $file"
            fi
        fi
    done

    log_success "Batch conversion complete"
    log_info "Successful: $count"
    if [[ $failed -gt 0 ]]; then
        log_warning "Failed: $failed"
    fi
}

# Main entry point
main() {
    # Check for help flag
    if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
        usage
        exit 0
    fi

    # Check for minimum arguments
    if [[ $# -lt 2 ]]; then
        log_error "Missing required arguments"
        usage
        exit 1
    fi

    # Check pandoc installation
    check_pandoc

    local command="$1"
    local input="$2"
    local output="${3:-}"

    # Generate output filename if not provided
    if [[ -z "$output" ]]; then
        output=$(generate_output_filename "$input" "$command")
        log_info "Auto-generated output filename: $output"
    fi

    # Execute command
    case "$command" in
        md2docx)
            md2docx "$input" "$output"
            ;;
        docx2md)
            docx2md "$input" "$output"
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
