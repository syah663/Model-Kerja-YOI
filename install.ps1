# ==============================================================================
# INSTALLER OTOMATIS MODEL KERJA YOI (AG v2.1)
# ==============================================================================
# Sistem: YOI | Versi: 2.1.0 | Platform: Windows PowerShell (5.1+ / Core 7+)
# Fungsi: Memasang dan menyinkronkan kerangka kerja YOI ke direktori proyek target
# ==============================================================================

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$TargetDir = (Get-Location).Path,

    [ValidateSet("All", "Core", "Rules", "DevSecOps", "Monitoring", "Blueprints")]
    [string]$Component = "All",

    [switch]$DryRun,
    [switch]$Force,
    [switch]$NoBackup
)

$ErrorActionPreference = "Stop"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   [AG v2.1] INSTALLER MODEL KERJA YOI (PORTABLE ENGINE)         " -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  Versi Framework : YOI v4.0 (AG v2.1)" -ForegroundColor White
Write-Host "  Direktori Target: $TargetDir" -ForegroundColor White
Write-Host "  Komponen Dipilih: $Component" -ForegroundColor White
Write-Host "  Mode Simulasi   : $(if ($DryRun) { 'AKTIF (DRY RUN)' } else { 'TIDAK (LIVE EXECUTION)' })" -ForegroundColor $(if ($DryRun) { 'Yellow' } else { 'Green' })
Write-Host "-----------------------------------------------------------------" -ForegroundColor DarkGray

# 1. Validasi Versi PowerShell
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "[ERROR] Diperlukan minimal PowerShell versi 5.1! Versi Anda: $($PSVersionTable.PSVersion)" -ForegroundColor Red
    exit 1
}

# 2. Validasi Direktori Target
if (-not (Test-Path $TargetDir)) {
    if ($DryRun) {
        Write-Host "[SIMULASI] Direktori target belum ada. Akan dibuat: $TargetDir" -ForegroundColor Yellow
    } else {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        Write-Host "[INFO] Membuat direktori target: $TargetDir" -ForegroundColor Green
    }
}

$TargetResolved = (Resolve-Path $TargetDir -ErrorAction SilentlyContinue)
if ($TargetResolved) { $TargetDir = $TargetResolved.Path }

# 3. Deteksi Repositori Git
$isGitRepo = Test-Path (Join-Path $TargetDir ".git")
if (-not $isGitRepo) {
    Write-Host "[PERINGATAN] Target bukan merupakan repositori Git." -ForegroundColor Yellow
    Write-Host "             Direkomendasikan menjalankan 'git init' pada target sebelum rilis produksi." -ForegroundColor Gray
} else {
    Write-Host "[INFO] Repositori Git terdeteksi pada target." -ForegroundColor Green
}

# 4. Direktori Sumber Installer
$SourceRoot = $PSScriptRoot
if (-not (Test-Path (Join-Path $SourceRoot "core/MODEL_KERJA.md"))) {
    Write-Host "[ERROR] Sumber installer tidak valid atau rusak (core/MODEL_KERJA.md tidak ditemukan)!" -ForegroundColor Red
    exit 1
}

# 5. Mekanisme Backup Otomatis
$BackupDir = Join-Path $TargetDir ("yoi_backup_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
$BackedUpFiles = 0

function Backup-FileIfNeeded ([string]$DestinationFile) {
    if ((Test-Path $DestinationFile) -and (-not $NoBackup) -and (-not $DryRun)) {
        if (-not (Test-Path $BackupDir)) {
            New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
            Write-Host "[BACKUP] Menginisialisasi folder cadangan: $BackupDir" -ForegroundColor DarkCyan
        }
        $relPath = [System.IO.Path]::GetRelativePath($TargetDir, $DestinationFile)
        $destBackup = Join-Path $BackupDir $relPath
        $destBackupDir = Split-Path $destBackup -Parent
        if (-not (Test-Path $destBackupDir)) {
            New-Item -ItemType Directory -Path $destBackupDir -Force | Out-Null
        }
        Copy-Item -Path $DestinationFile -Destination $destBackup -Force
        $script:BackedUpFiles++
    }
}

# 6. Pemetaan Komponen yang Akan Dipasang
$InstallMap = @()

# Komponen Core
if ($Component -in @("All", "Core")) {
    $InstallMap += @(
        @{ Src = "core/MODEL_KERJA.md"; Dest = "MODEL_KERJA.md"; Type = "File" },
        @{ Src = "core/PURSUIT_GOALS.template.md"; Dest = "PURSUIT_GOALS.md"; Type = "FileConditionEmpty" },
        @{ Src = "core/ETHICS_AND_COMPLIANCE.md"; Dest = "docs/ETHICS_AND_COMPLIANCE.md"; Type = "File" }
    )
}

# Komponen Rules
if ($Component -in @("All", "Rules")) {
    $InstallMap += @(
        @{ Src = "agent-rules/gemini/mandatory_dual_mode.md"; Dest = ".gemini/rules/mandatory_dual_mode.md"; Type = "File" },
        @{ Src = "agent-rules/cursor/.cursorrules"; Dest = ".cursorrules"; Type = "File" },
        @{ Src = "agent-rules/claude/CLAUDE.md"; Dest = "CLAUDE.md"; Type = "File" }
    )
}

# Komponen DevSecOps
if ($Component -in @("All", "DevSecOps")) {
    $InstallMap += @(
        @{ Src = "devsecops/quality_gate.ps1"; Dest = "scripts/quality_gate.ps1"; Type = "File" },
        @{ Src = "devsecops/quality_gate.sh"; Dest = "scripts/quality_gate.sh"; Type = "File" },
        @{ Src = "devsecops/.gitleaks.toml"; Dest = ".gitleaks.toml"; Type = "File" },
        @{ Src = ".github/workflows/template-ci.yml"; Dest = ".github/workflows/ci.yml"; Type = "FileConditionEmpty" }
    )
}

# Komponen Monitoring
if ($Component -in @("All", "Monitoring")) {
    $InstallMap += @(
        @{ Src = "monitoring/yoi_monitor.ps1"; Dest = "scripts/yoi_monitor.ps1"; Type = "File" },
        @{ Src = "monitoring/activity_ledger.template.json"; Dest = "docs/monitoring/activity_ledger.json"; Type = "FileConditionEmpty" },
        @{ Src = "monitoring/ACTIVITY_TRACKER.template.md"; Dest = "docs/monitoring/ACTIVITY_TRACKER.md"; Type = "FileConditionEmpty" }
    )
}

# Komponen Blueprints
if ($Component -in @("All", "Blueprints")) {
    $InstallMap += @(
        @{ Src = "blueprints/security/php/Csrf.php"; Dest = "app/Security/Csrf.php"; Type = "FileConditionEmpty" },
        @{ Src = "blueprints/security/php/Origin.php"; Dest = "app/Security/Origin.php"; Type = "FileConditionEmpty" },
        @{ Src = "blueprints/security/php/RateLimiter.php"; Dest = "app/Security/RateLimiter.php"; Type = "FileConditionEmpty" },
        @{ Src = "blueprints/security/js/csrf.js"; Dest = "public/assets/js/csrf.js"; Type = "FileConditionEmpty" },
        @{ Src = "blueprints/templates/raw_test_data/LOG_BUKTI.template.md"; Dest = "docs/raw_test_data/LOG_BUKTI.md"; Type = "FileConditionEmpty" }
    )
}

# 7. Eksekusi Instalasi
Write-Host "`n[PROSES INSTALASI]" -ForegroundColor Yellow
$InstalledCount = 0
$SkippedCount = 0

# Folder wajib proyek
$BaseDirs = @("docs/raw_test_data", "docs/skripsi", "docs/monitoring", "scripts", ".gemini/rules")
foreach ($bd in $BaseDirs) {
    $targetBD = Join-Path $TargetDir $bd
    if (-not (Test-Path $targetBD)) {
        if ($DryRun) {
            Write-Host "  [SIMULASI DIR] Akan membuat folder: $bd" -ForegroundColor Cyan
        } else {
            New-Item -ItemType Directory -Path $targetBD -Force | Out-Null
            Write-Host "  [DIR DIBUAT] $bd" -ForegroundColor DarkGreen
        }
    }
}

foreach ($item in $InstallMap) {
    $srcPath = Join-Path $SourceRoot $item.Src
    $destPath = Join-Path $TargetDir $item.Dest
    $destFolder = Split-Path -Path $destPath -Parent

    if (-not (Test-Path $srcPath)) {
        Write-Host "  [LEWATI] Sumber tidak ada: $($item.Src)" -ForegroundColor DarkGray
        continue
    }

    $destExists = Test-Path $destPath

    # Logika penanganan kondisi file
    if ($destExists -and ($item.Type -eq "FileConditionEmpty") -and (-not $Force)) {
        Write-Host "  [LEWATI] Berkas sudah ada (dipertahankan): $($item.Dest)" -ForegroundColor Gray
        $SkippedCount++
        continue
    }

    if ($DryRun) {
        if ($destExists) {
            Write-Host "  [SIMULASI TIMPA] $($item.Dest) (akan dibackup sebelum ditimpa)" -ForegroundColor Yellow
        } else {
            Write-Host "  [SIMULASI PASANG] $($item.Dest)" -ForegroundColor Green
        }
        $InstalledCount++
    } else {
        if (-not (Test-Path $destFolder)) {
            New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
        }
        Backup-FileIfNeeded -DestinationFile $destPath
        Copy-Item -Path $srcPath -Destination $destPath -Force
        Write-Host "  [SUKSES PASANG] $($item.Dest)" -ForegroundColor Green
        $InstalledCount++
    }
}

# 8. Ringkasan Laporan Instalasi
Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host "   RINGKASAN HASIL INSTALASI MODEL KERJA YOI (AG v2.1)           " -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  Status            : $(if ($DryRun) { 'SIMULASI SELESAI' } else { 'BERHASIL TERPASANG' })" -ForegroundColor Green
Write-Host "  Berkas Dipasang   : $InstalledCount" -ForegroundColor White
Write-Host "  Berkas Dilewati   : $SkippedCount" -ForegroundColor Gray
Write-Host "  Berkas Dicadangkan: $BackedUpFiles $(if ($BackedUpFiles -gt 0) { "-> ($BackupDir)" } else { '' })" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "  Langkah Selanjutnya:" -ForegroundColor White
Write-Host "  1. Buka file PURSUIT_GOALS.md pada proyek dan sesuaikan sasaran." -ForegroundColor Gray
Write-Host "  2. Gunakan instruksi 'dev' untuk coding dan 'skripsi' untuk riset." -ForegroundColor Gray
Write-Host "  3. Jalankan 'powershell -File scripts/yoi_monitor.ps1 -Status' untuk cek status." -ForegroundColor Gray
Write-Host "=================================================================" -ForegroundColor Cyan
