# Script Validasi Integritas Repository Model-Kerja-YOI
# Identitas Mesin: AG v2.1 | Sistem: YOI

param(
    [string]$RepoRoot = "."
)

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   [AG v2.1] VALIDASI INTEGRITAS REPOSITORY YOI       " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$HasError = $false

# 1. Validasi Struktur Wajib
Write-Host "`n[1/5] Memeriksa Kelengkapan Struktur Direktori..." -ForegroundColor Yellow
$requiredDirs = @(
    "core",
    "agent-rules/gemini",
    "agent-rules/cursor",
    "agent-rules/claude",
    "devsecops",
    "monitoring",
    "blueprints/security/php",
    "blueprints/security/js",
    "blueprints/templates/raw_test_data",
    "scripts/validation",
    ".github/workflows"
)

foreach ($dir in $requiredDirs) {
    $fullPath = Join-Path $RepoRoot $dir
    if (Test-Path $fullPath) {
        Write-Host "  [OK] $dir" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $dir" -ForegroundColor Red
        $HasError = $true
    }
}

# 2. Validasi Sintaks Skrip PowerShell
Write-Host "`n[2/5] Memeriksa Sintaks Skrip PowerShell (*.ps1)..." -ForegroundColor Yellow
$psFiles = Get-ChildItem -Path $RepoRoot -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue

foreach ($file in $psFiles) {
    $errors = $null
    $tokens = [System.Management.Automation.PSParser]::Tokenize((Get-Content $file.FullName -Raw), [ref]$errors)
    if ($errors.Count -eq 0) {
        Write-Host "  [PASS] $($file.Name) - Sintaks valid" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $($file.Name) - Ditemukan $($errors.Count) kesalahan sintaks!" -ForegroundColor Red
        foreach ($err in $errors) {
            Write-Host "         Baris $($err.StartLine): $($err.Message)" -ForegroundColor Red
        }
        $HasError = $true
    }
}

# 3. Validasi Sintaks JSON
Write-Host "`n[3/5] Memeriksa Integritas File JSON..." -ForegroundColor Yellow
$jsonFiles = Get-ChildItem -Path $RepoRoot -Filter *.json -Recurse -ErrorAction SilentlyContinue

foreach ($file in $jsonFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding utf8 | ConvertFrom-Json
        Write-Host "  [PASS] $($file.Name) - JSON valid" -ForegroundColor Green
    } catch {
        Write-Host "  [FAIL] $($file.Name) - Format JSON tidak valid: $($_.Exception.Message)" -ForegroundColor Red
        $HasError = $true
    }
}

# 4. Pemindaian Berkas Sensitif / Secret
Write-Host "`n[4/5] Memeriksa Pencegahan Berkas Rahasia (.env / secrets)..." -ForegroundColor Yellow
$secretPatterns = @(".env", ".env.*", "*.secret", "*.key", "*.pem")
$foundSecrets = Get-ChildItem -Path $RepoRoot -Include $secretPatterns -Recurse -ErrorAction SilentlyContinue

if ($foundSecrets.Count -eq 0) {
    Write-Host "  [PASS] Bersih! Tidak ditemukan file .env atau secret terlarang." -ForegroundColor Green
} else {
    foreach ($sec in $foundSecrets) {
        Write-Host "  [FAIL] File sensitif ditemukan: $($sec.FullName)" -ForegroundColor Red
        $HasError = $true
    }
}

# 5. Validasi Berkas Doktrin & Aturan
Write-Host "`n[5/5] Memeriksa Integritas Dokumen Doktrin & Aturan..." -ForegroundColor Yellow
$essentialFiles = @(
    "core/MODEL_KERJA.md",
    "core/PURSUIT_GOALS.template.md",
    "core/ETHICS_AND_COMPLIANCE.md",
    "agent-rules/gemini/mandatory_dual_mode.md",
    "agent-rules/cursor/.cursorrules",
    "agent-rules/claude/CLAUDE.md",
    "devsecops/quality_gate.ps1",
    "monitoring/yoi_monitor.ps1",
    "blueprints/security/php/Csrf.php",
    "blueprints/security/js/csrf.js"
)

foreach ($f in $essentialFiles) {
    $targetPath = Join-Path $RepoRoot $f
    if (Test-Path $targetPath) {
        Write-Host "  [OK] $f tersedia" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] Berkas wajib belum ada: $f" -ForegroundColor Red
        $HasError = $true
    }
}

Write-Host "`n======================================================" -ForegroundColor Cyan
if ($HasError) {
    Write-Host "  HASIL: VALIDASI GAGAL! Perbaiki komponen bermasalah. " -ForegroundColor Red
    Write-Host "======================================================" -ForegroundColor Cyan
    exit 1
} else {
    Write-Host "  HASIL: INTEGRITAS REPOSITORY 100% VALID & SIAP PAKAI! " -ForegroundColor Green
    Write-Host "======================================================" -ForegroundColor Cyan
    exit 0
}
