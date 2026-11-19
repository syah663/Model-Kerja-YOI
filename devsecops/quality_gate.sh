#!/usr/bin/env bash
# YOI DevSecOps Quality Gate Pipeline (Linux / macOS / WSL)
# Identitas Mesin: AG v2.1 | Sistem: YOI

set -euo pipefail

TARGET_DIR="${1:-.}"
LOG_FILE="${2:-docs/raw_test_data/devsecops_audit_latest.txt}"

echo "======================================================"
echo "   [AG v2.1] DEVSECOPS QUALITY GATE PIPELINE (YOI)   "
echo "======================================================"

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
mkdir -p "$(dirname "$LOG_FILE")"
echo "=== LOG DEVSECOPS QUALITY GATE: $TIMESTAMP ===" > "$LOG_FILE"

HAS_ERROR=0
HAS_WARNING=0

# 1. PHP Syntax Linting
echo ""
echo "[1/3] Memeriksa Sintaks PHP (PHP Lint)..."
if command -v php >/dev/null 2>&1; then
    PHP_FILES=$(find "$TARGET_DIR" -type f -name "*.php" ! -path "*/vendor/*" ! -path "*/storage/*" 2>/dev/null || true)
    if [ -z "$PHP_FILES" ]; then
        echo "  [INFO] Tidak ada berkas PHP yang ditemukan."
        echo "1. PHP Lint: SKIPPED (No PHP files found)" >> "$LOG_FILE"
    else
        LINT_ERRORS=0
        for f in $PHP_FILES; do
            if ! php -l "$f" >/dev/null 2>&1; then
                echo "  [FAIL] Sintaks Error: $f"
                php -l "$f" || true
                echo "  [ERROR] $f" >> "$LOG_FILE"
                LINT_ERRORS=$((LINT_ERRORS + 1))
                HAS_ERROR=1
            fi
        done
        if [ "$LINT_ERRORS" -eq 0 ]; then
            echo "  [PASS] Seluruh berkas PHP lolos uji sintaks!"
            echo "1. PHP Lint: PASS (0 errors)" >> "$LOG_FILE"
        fi
    fi
else
    echo "  [FAIL] PHP CLI tidak ditemukan di sistem."
    echo "1. PHP Lint: FAILED (PHP CLI missing)" >> "$LOG_FILE"
    HAS_ERROR=1
fi

# 2. Gitleaks / Secret Scanning
echo ""
echo "[2/3] Memindai Kebocoran Kredensial / Secret (Gitleaks)..."
if command -v gitleaks >/dev/null 2>&1; then
    if gitleaks detect --source="$TARGET_DIR" --no-git -v; then
        echo "  [PASS] Bersih! Tidak ada rahasia atau kredensial yang bocor."
        echo "2. Gitleaks: PASS (0 secrets detected)" >> "$LOG_FILE"
    else
        echo "  [FAIL] Terdeteksi potensi kebocoran rahasia!"
        echo "2. Gitleaks: FAIL (Potential secrets found)" >> "$LOG_FILE"
        HAS_ERROR=1
    fi
else
    echo "  [WARN] Gitleaks CLI tidak terpasang di sistem lokal."
    echo "2. Gitleaks: UNVERIFIED (Binary not installed locally; delegated to CI)" >> "$LOG_FILE"
    HAS_WARNING=1
fi

# 3. Composer Security Audit
echo ""
echo "[3/3] Memeriksa Keamanan Dependensi (Composer Audit)..."
if [ -f "$TARGET_DIR/composer.json" ]; then
    if command -v composer >/dev/null 2>&1; then
        if (cd "$TARGET_DIR" && composer audit); then
            echo "  [PASS] Seluruh paket dependensi aman (Zero CVE)!"
            echo "3. Composer Audit: PASS (No vulnerabilities)" >> "$LOG_FILE"
        else
            echo "  [FAIL] Ditemukan kerentanan dependensi!"
            echo "3. Composer Audit: FAIL (Vulnerabilities found)" >> "$LOG_FILE"
            HAS_ERROR=1
        fi
    else
        echo "  [WARN] composer.json ditemukan namun Composer CLI tidak tersedia."
        echo "3. Composer Audit: UNVERIFIED (Composer CLI missing)" >> "$LOG_FILE"
        HAS_WARNING=1
    fi
else
    echo "  [INFO] composer.json tidak ditemukan. Audit dependensi dilewati."
    echo "3. Composer Audit: SKIPPED (composer.json missing)" >> "$LOG_FILE"
fi

echo ""
echo "======================================================"
if [ "$HAS_ERROR" -ne 0 ]; then
    echo "  HASIL: QUALITY GATE GAGAL. Perbaiki kesalahan!"
    echo "  Log bukti tersimpan di: $LOG_FILE"
    echo "======================================================"
    exit 1
elif [ "$HAS_WARNING" -ne 0 ]; then
    echo "  HASIL: QUALITY GATE LOLOS DENGAN PERINGATAN."
    echo "  Log bukti tersimpan di: $LOG_FILE"
    echo "======================================================"
    exit 0
else
    echo "  HASIL: QUALITY GATE LOLOS PENUH (100% CLEAN)!"
    echo "  Log bukti tersimpan di: $LOG_FILE"
    echo "======================================================"
    exit 0
fi
