# YOI DevSecOps Quality Gate (PHP Lint + Secret Detection + Dependency Audit)
# Identitas Mesin: AG v2.1 | Sistem: YOI

param(
    [string]$TargetDir = ".",
    [string]$LogFile = "docs/raw_test_data/devsecops_audit_latest.txt"
)

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   [AG v2.1] DEVSECOPS QUALITY GATE PIPELINE (YOI)   " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Pastikan folder log tersedia
$logDir = Split-Path -Path $LogFile -Parent
if ($logDir -and -not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

"=== LOG DEVSECOPS QUALITY GATE: $Timestamp ===" | Out-File -FilePath $LogFile -Encoding utf8

$HasError = $false
$HasWarning = $false

# 1. Deteksi PHP Binary
$phpCmd = Get-Command php -ErrorAction SilentlyContinue
$phpPath = if ($phpCmd) { "php" } else {
    $possiblePaths = @(
        "C:\laragon\bin\php\php-8.3.36-Win32-vs16-x64\php.exe",
        "C:\laragon\bin\php\*\php.exe",
        "C:\xampp\php\php.exe",
        "D:\xampp\php\php.exe"
    )
    $found = Resolve-Path $possiblePaths -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) { $found.Path } else { $null }
}

# 1. PHP Syntax Linting
Write-Host "`n[1/3] Memeriksa Sintaks PHP (PHP Lint)..." -ForegroundColor Yellow
$scanFolders = @("app", "public", "src", "config") | Where-Object { Test-Path (Join-Path $TargetDir $_) }

if ($null -eq $phpPath) {
    Write-Host "  [FAIL] PHP CLI tidak ditemukan di sistem (PATH / Laragon / XAMPP)." -ForegroundColor Red
    "1. PHP Lint: FAILED (PHP runtime missing)" | Out-File -FilePath $LogFile -Append -Encoding utf8
    $HasError = $true
} else {
    $phpFiles = @()
    foreach ($dir in $scanFolders) {
        $phpFiles += Get-ChildItem -Path (Join-Path $TargetDir $dir) -Filter *.php -Recurse -ErrorAction SilentlyContinue
    }

    if ($phpFiles.Count -eq 0) {
        Write-Host "  [INFO] Tidak ada berkas PHP ditemukan di folder target ($($scanFolders -join ', '))." -ForegroundColor Gray
        "1. PHP Lint: SKIPPED (No PHP files found in target folders)" | Out-File -FilePath $LogFile -Append -Encoding utf8
    } else {
        Write-Host "  [INFO] Runtime: $phpPath" -ForegroundColor Gray
        $lintErrors = 0
        foreach ($file in $phpFiles) {
            $lintResult = & $phpPath -l $file.FullName 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  [FAIL] Sintaks Error: $($file.FullName)" -ForegroundColor Red
                Write-Host "         $lintResult" -ForegroundColor Red
                "  [ERROR] $($file.FullName) : $lintResult" | Out-File -FilePath $LogFile -Append -Encoding utf8
                $lintErrors++
                $HasError = $true
            }
        }
        if ($lintErrors -eq 0) {
            Write-Host "  [PASS] Seluruh $($phpFiles.Count) berkas PHP lolos uji sintaks!" -ForegroundColor Green
            "1. PHP Lint: PASS ($($phpFiles.Count) files scanned, 0 errors)" | Out-File -FilePath $LogFile -Append -Encoding utf8
        }
    }
}

# 2. Gitleaks / Secret Scanning
Write-Host "`n[2/3] Memindai Kebocoran Kredensial / Secret (Gitleaks)..." -ForegroundColor Yellow
$gitleaksCmd = Get-Command gitleaks -ErrorAction SilentlyContinue
if ($null -ne $gitleaksCmd) {
    $leakOutput = & gitleaks detect --source="$TargetDir" --no-git -v 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [PASS] Bersih! Tidak ditemukan kredensial atau rahasia yang bocor." -ForegroundColor Green
        "2. Gitleaks: PASS (0 secrets detected)" | Out-File -FilePath $LogFile -Append -Encoding utf8
    } else {
        Write-Host "  [FAIL] Terdeteksi potensi kebocoran rahasia!" -ForegroundColor Red
        Write-Host $leakOutput -ForegroundColor Red
        "2. Gitleaks: FAIL (Potential secrets found)" | Out-File -FilePath $LogFile -Append -Encoding utf8
        $HasError = $true
    }
} else {
    Write-Host "  [WARN] Gitleaks CLI belum terpasang di sistem lokal." -ForegroundColor Yellow
    Write-Host "         (Pemindaian rahasia lokal dilewati; wajib dijalankan pada CI GitHub Actions)." -ForegroundColor Gray
    "2. Gitleaks: UNVERIFIED (Binary not installed locally; delegated to CI)" | Out-File -FilePath $LogFile -Append -Encoding utf8
    $HasWarning = $true
}

# 3. Composer Security Audit (SCA)
Write-Host "`n[3/3] Memeriksa Keamanan Dependensi (Composer Audit)..." -ForegroundColor Yellow
$composerFile = Join-Path $TargetDir "composer.json"
if (Test-Path $composerFile) {
    $composerCmd = Get-Command composer -ErrorAction SilentlyContinue
    if ($null -ne $composerCmd) {
        $composerAudit = & composer audit 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [PASS] Seluruh paket dependensi aman (Zero CVE)!" -ForegroundColor Green
            "3. Composer Audit: PASS (No vulnerabilities in dependencies)" | Out-File -FilePath $LogFile -Append -Encoding utf8
        } else {
            Write-Host "  [FAIL] Ditemukan kerentanan pada dependensi!" -ForegroundColor Red
            Write-Host $composerAudit -ForegroundColor Red
            "3. Composer Audit: FAIL (Vulnerabilities detected)" | Out-File -FilePath $LogFile -Append -Encoding utf8
            $HasError = $true
        }
    } else {
        Write-Host "  [WARN] composer.json ditemukan namun Composer CLI tidak tersedia." -ForegroundColor Yellow
        "3. Composer Audit: UNVERIFIED (Composer CLI missing)" | Out-File -FilePath $LogFile -Append -Encoding utf8
        $HasWarning = $true
    }
} else {
    Write-Host "  [INFO] composer.json tidak ditemukan. Audit dependensi dilewati." -ForegroundColor Gray
    "3. Composer Audit: SKIPPED (composer.json not present)" | Out-File -FilePath $LogFile -Append -Encoding utf8
}

Write-Host "`n======================================================" -ForegroundColor Cyan
if ($HasError) {
    Write-Host "  HASIL: QUALITY GATE GAGAL. Perbaiki kesalahan!       " -ForegroundColor Red
    Write-Host "  Log bukti tersimpan di: $LogFile" -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Cyan
    exit 1
} elseif ($HasWarning) {
    Write-Host "  HASIL: QUALITY GATE LOLOS DENGAN PERINGATAN.         " -ForegroundColor Yellow
    Write-Host "  Log bukti tersimpan di: $LogFile" -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "  HASIL: QUALITY GATE LOLOS PENUH (100% CLEAN)!        " -ForegroundColor Green
    Write-Host "  Log bukti tersimpan di: $LogFile" -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Cyan
    exit 0
}
