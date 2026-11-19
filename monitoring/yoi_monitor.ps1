# Script Sistem Monitoring Aktivitas & Pembaruan Sistem YOI
# Identitas Mesin: AG v2.1 | Sistem: YOI

param(
    [switch]$Status,
    [switch]$Log,
    [switch]$Backlog,
    [string]$Mode = "dev",
    [string]$Task = "",
    [string]$Artifact = "",
    [string]$UpdateTitle = "",
    [string]$UpdateTarget = "dev",
    [string]$Priority = "MEDIUM",
    [string]$LedgerPath = "docs/monitoring/activity_ledger.json",
    [string]$TrackerPath = "docs/monitoring/ACTIVITY_TRACKER.md"
)

if (-not (Test-Path $LedgerPath)) {
    Write-Host "[AG v2.1] [ERROR] Berkas ledger '$LedgerPath' tidak ditemukan!" -ForegroundColor Red
    Write-Host "         Pastikan template di docs/monitoring/ telah diinisialisasi." -ForegroundColor Yellow
    exit 1
}

$rawJson = Get-Content -Path $LedgerPath -Raw -Encoding utf8
$ledger = $rawJson | ConvertFrom-Json

# 1. Menampilkan Status Monitoring
if ($Status -or (-not $Log -and -not $Backlog -and [string]::IsNullOrEmpty($UpdateTitle))) {
    Write-Host "`n=======================================================" -ForegroundColor Cyan
    Write-Host "   [AG v2.1] SISTEM MONITORING YOI - STATUS AKTIF      " -ForegroundColor Cyan
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host "  Sistem          : $($ledger.system)" -ForegroundColor White
    Write-Host "  Identitas Mesin : $($ledger.engine_identity)" -ForegroundColor White
    Write-Host "  Proyek          : $($ledger.project)" -ForegroundColor White
    Write-Host "  Mode Terakhir   : [$($ledger.current_mode)]" -ForegroundColor Yellow
    Write-Host "  Terakhir Update : $($ledger.last_updated)" -ForegroundColor Gray
    Write-Host "-------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  STATUS KEAMANAN (SOFTWARE DEV):" -ForegroundColor White
    Write-Host "  • CSRF Protection  : $($ledger.security_compliance.csrf_protection.status)" -ForegroundColor Green
    Write-Host "  • SQLi (PDO Native): $($ledger.security_compliance.sqli_protection.status)" -ForegroundColor Green
    Write-Host "  • XSS (Sanitize)   : $($ledger.security_compliance.xss_protection.status)" -ForegroundColor Green
    Write-Host "  • DevSecOps Gate   : $($ledger.security_compliance.devsecops_quality_gate.status)" -ForegroundColor Green
    Write-Host "-------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  PROGRES SKRIPSI S1:" -ForegroundColor White
    Write-Host "  • Bab I  : $($ledger.thesis_milestones.bab_1_pendahuluan)" -ForegroundColor White
    Write-Host "  • Bab II : $($ledger.thesis_milestones.bab_2_tinjauan_pustaka)" -ForegroundColor White
    Write-Host "  • Bab III: $($ledger.thesis_milestones.bab_3_metodologi)" -ForegroundColor White
    Write-Host "  • Bab IV : $($ledger.thesis_milestones.bab_4_hasil_pembahasan)" -ForegroundColor Yellow
    Write-Host "  • Bab V  : $($ledger.thesis_milestones.bab_5_kesimpulan)" -ForegroundColor Gray
    Write-Host "=======================================================`n" -ForegroundColor Cyan
    exit 0
}

# 2. Menampilkan Backlog Pembaruan Berikutnya
if ($Backlog) {
    Write-Host "`n=======================================================" -ForegroundColor Cyan
    Write-Host "   [AG v2.1] SISTEM MONITORING YOI - DAFTAR PEMBAHARUAN " -ForegroundColor Cyan
    Write-Host "=======================================================" -ForegroundColor Cyan
    if ($ledger.update_backlog.Count -eq 0) {
        Write-Host "  (Belum ada item backlog pembaruan terdaftar)" -ForegroundColor Gray
    } else {
        foreach ($item in $ledger.update_backlog) {
            $color = if ($item.priority -eq "HIGH") { "Red" } else { "Yellow" }
            Write-Host "  [$($item.id)] [$($item.target)] ($($item.priority)) - $($item.title) [Status: $($item.status)]" -ForegroundColor $color
        }
    }
    Write-Host "=======================================================`n" -ForegroundColor Cyan
    exit 0
}

# 3. Mencatat Log Aktivitas Baru
if ($Log) {
    if ([string]::IsNullOrEmpty($Task)) {
        Write-Host "[AG v2.1] [ERROR] Parameter -Task wajib diisi untuk mencatat log aktivitas!" -ForegroundColor Red
        exit 1
    }

    $newId = "ACT-" + ("{0:D3}" -f ($ledger.activity_history.Count + 1))
    $timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")
    
    $newEntry = [PSCustomObject]@{
        id = $newId
        timestamp = $timestamp
        mode = $Mode.ToLower()
        actor = "Mahasiswa & AG"
        task = $Task
        artifact = if ($Artifact) { $Artifact } else { "-" }
        status = "SUCCESS"
    }

    $ledger.activity_history += $newEntry
    $ledger.last_updated = $timestamp
    $ledger.current_mode = $Mode.ToLower()

    # Simpan JSON
    $ledger | ConvertTo-Json -Depth 10 | Set-Content -Path $LedgerPath -Encoding utf8
    
    # Tambahkan baris ke ACTIVITY_TRACKER.md jika file ada
    if (Test-Path $TrackerPath) {
        $rowText = "| **$newId** | $((Get-Date).ToString("yyyy-MM-dd HH:mm")) | ``$($Mode.ToLower())`` | Mahasiswa & AG | $Task | ``$($Artifact)`` | SUCCESS |"
        Add-Content -Path $TrackerPath -Value $rowText
    }

    Write-Host "[AG v2.1] [SUCCESS] Aktivitas $newId berhasil dicatat ke dalam log monitoring YOI!" -ForegroundColor Green
    exit 0
}
