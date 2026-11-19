#!/usr/bin/env bash
# ==============================================================================
# INSTALLER OTOMATIS MODEL KERJA YOI (AG v2.1) - LINUX / MACOS
# ==============================================================================
# Sistem: YOI | Versi: 2.1.0 | Platform: Bash (Linux / macOS / WSL)
# ==============================================================================

set -euo pipefail

TARGET_DIR="${1:-$(pwd)}"
COMPONENT="${2:-All}"
DRY_RUN=0
FORCE=0
NO_BACKUP=0

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --force) FORCE=1 ;;
        --no-backup) NO_BACKUP=1 ;;
    esac
done

echo "================================================================="
echo "   [AG v2.1] INSTALLER MODEL KERJA YOI (PORTABLE ENGINE)         "
echo "================================================================="
echo "  Versi Framework : YOI v4.0 (AG v2.1)"
echo "  Direktori Target: $TARGET_DIR"
echo "  Komponen Dipilih: $COMPONENT"
if [ "$DRY_RUN" -eq 1 ]; then
    echo "  Mode Simulasi   : AKTIF (DRY RUN)"
else
    echo "  Mode Simulasi   : TIDAK (LIVE EXECUTION)"
fi
echo "-----------------------------------------------------------------"

SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$SOURCE_ROOT/core/MODEL_KERJA.md" ]; then
    echo "[ERROR] Berkas sumber installer tidak valid!"
    exit 1
fi

mkdir -p "$TARGET_DIR"

BACKUP_DIR="$TARGET_DIR/yoi_backup_$(date "+%Y%m%d_%H%M%S")"
BACKED_UP_COUNT=0

backup_file_if_needed() {
    local dest_file="$1"
    if [ -f "$dest_file" ] && [ "$NO_BACKUP" -eq 0 ] && [ "$DRY_RUN" -eq 0 ]; then
        if [ ! -d "$BACKUP_DIR" ]; then
            mkdir -p "$BACKUP_DIR"
            echo "[BACKUP] Folder cadangan dibuat: $BACKUP_DIR"
        fi
        local rel_path="${dest_file#"$TARGET_DIR/"}"
        local dest_bak="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$dest_bak")"
        cp "$dest_file" "$dest_bak"
        BACKED_UP_COUNT=$((BACKED_UP_COUNT + 1))
    fi
}

copy_asset() {
    local src="$SOURCE_ROOT/$1"
    local dest="$TARGET_DIR/$2"
    local cond="${3:-always}"

    if [ ! -f "$src" ]; then
        return
    fi

    if [ -f "$dest" ] && [ "$cond" = "if_empty" ] && [ "$FORCE" -eq 0 ]; then
        echo "  [LEWATI] Berkas sudah ada: $2"
        return
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        if [ -f "$dest" ]; then
            echo "  [SIMULASI TIMPA] $2"
        else
            echo "  [SIMULASI PASANG] $2"
        fi
    else
        mkdir -p "$(dirname "$dest")"
        backup_file_if_needed "$dest"
        cp "$src" "$dest"
        echo "  [SUKSES PASANG] $2"
    fi
}

echo ""
echo "[PROSES INSTALASI]"
mkdir -p "$TARGET_DIR/docs/raw_test_data" "$TARGET_DIR/docs/skripsi" "$TARGET_DIR/docs/monitoring" "$TARGET_DIR/scripts" "$TARGET_DIR/.gemini/rules"

# 1. Core
copy_asset "core/MODEL_KERJA.md" "MODEL_KERJA.md" "always"
copy_asset "core/PURSUIT_GOALS.template.md" "PURSUIT_GOALS.md" "if_empty"
copy_asset "core/ETHICS_AND_COMPLIANCE.md" "docs/ETHICS_AND_COMPLIANCE.md" "always"

# 2. Rules
copy_asset "agent-rules/gemini/mandatory_dual_mode.md" ".gemini/rules/mandatory_dual_mode.md" "always"
copy_asset "agent-rules/cursor/.cursorrules" ".cursorrules" "always"
copy_asset "agent-rules/claude/CLAUDE.md" "CLAUDE.md" "always"

# 3. DevSecOps
copy_asset "devsecops/quality_gate.sh" "scripts/quality_gate.sh" "always"
copy_asset "devsecops/quality_gate.ps1" "scripts/quality_gate.ps1" "always"
copy_asset "devsecops/.gitleaks.toml" ".gitleaks.toml" "always"
copy_asset ".github/workflows/template-ci.yml" ".github/workflows/ci.yml" "if_empty"

# 4. Monitoring
copy_asset "monitoring/yoi_monitor.ps1" "scripts/yoi_monitor.ps1" "always"
copy_asset "monitoring/activity_ledger.template.json" "docs/monitoring/activity_ledger.json" "if_empty"
copy_asset "monitoring/ACTIVITY_TRACKER.template.md" "docs/monitoring/ACTIVITY_TRACKER.md" "if_empty"

# 5. Blueprints
copy_asset "blueprints/security/php/Csrf.php" "app/Security/Csrf.php" "if_empty"
copy_asset "blueprints/security/php/Origin.php" "app/Security/Origin.php" "if_empty"
copy_asset "blueprints/security/php/RateLimiter.php" "app/Security/RateLimiter.php" "if_empty"
copy_asset "blueprints/security/js/csrf.js" "public/assets/js/csrf.js" "if_empty"
copy_asset "blueprints/templates/raw_test_data/LOG_BUKTI.template.md" "docs/raw_test_data/LOG_BUKTI.md" "if_empty"

echo ""
echo "================================================================="
echo "   RINGKASAN HASIL INSTALASI MODEL KERJA YOI (AG v2.1)           "
echo "================================================================="
if [ "$DRY_RUN" -eq 1 ]; then
    echo "  Status : SIMULASI SELESAI (DRY RUN)"
else
    echo "  Status : BERHASIL TERPASANG"
fi
echo "  Cadangan Dibuat : $BACKED_UP_COUNT berkas"
echo "================================================================="
