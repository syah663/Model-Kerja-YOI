# MODEL KERJA YOI (AG v2.1)
### Pusat Tata Kelola, Distribusi, & Standar Operasional AI Agentic untuk Rekayasa Perangkat Lunak dan Skripsi S1

[![YOI Version](https://img.shields.io/badge/YOI-v4.0.0-blue.svg)](./core/MODEL_KERJA.md)
[![Agent Identity](https://img.shields.io/badge/Agent_Engine-AG_v2.1-green.svg)](./agent-rules/gemini/mandatory_dual_mode.md)
[![Policy](https://img.shields.io/badge/Governance-Zero--Bypass-red.svg)](./core/MODEL_KERJA.md)
[![Security Standard](https://img.shields.io/badge/Security-OWASP_Top_10_%2B_CSRF-purple.svg)](./blueprints/security/php/Csrf.php)
[![License](https://img.shields.io/badge/License-MIT_Style-lightgrey.svg)](./LICENSE)

Repository ini merupakan **pusat penyimpanan, pengelolaan, distribusi, dan pemeliharaan resmi** model kerja AI **YOI** dengan mesin tata kelola **AG v2.1**. Kerangka kerja ini dirancang untuk memastikan mahasiswa dan asisten kecerdasan buatan beroperasi secara disiplin, aman, dan terukur dalam menyelesaikan dua keluaran secara bersamaan: **sistem perangkat lunak siap rilis** dan **naskah skripsi S1 berbasis bukti empiris yang lolos sidang**.

---

## 1. Arsitektur Inti YOI: Dual-Mode Isolation

Model kerja YOI memisahkan seluruh alur kerja ke dalam dua mode operasional terisolasi untuk mencegah bias konteks (*context drift*):

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        TATA KELOLA DUAL-MODE SISTEM YOI                                │
├───────────────────────────────────────────┬────────────────────────────────────────────┤
│           INSTRUKSI: `dev`                │          INSTRUKSI: `skripsi`              │
│   (Mode Rekayasa Perangkat Lunak)         │    (Mode Riset & Penulisan Skripsi S1)     │
├───────────────────────────────────────────┼────────────────────────────────────────────┤
│ • Kata Kunci: `dev`                       │ • Kata Kunci: `skripsi`                    │
│ • Mindset: Senior AppSec & Full-Stack     │ • Mindset: Konsultan Metodologi & Reviewer │
│ • Cakupan: Seluruh SDLC (SRS, UML, ERD,   │ • Cakupan: Proposal, Bab I s/d Bab V,      │
│   PHP 8.2+, MySQL Spatial, PWA,           │   Kajian Pustaka, Metodologi Ilmiah,       │
│   DevSecOps Quality Gate, Penetrasi).     │   Analisis Empiris Hasil Uji, Sitasi       │
│ • Standar Keamanan: OWASP Top 10 lengkap  │   Zotero ber-DOI, Slide Ujian Sidang.      │
│   dengan proteksi CSRF end-to-end.        │ • Sumber Bukti: Wajib membaca bukti uji    │
│ • Larangan Keras: Dilarang menyusun naskah│   empiris dari docs/raw_test_data/.        │
│   akademik/bab skripsi di mode ini.       │ • Larangan Keras: Dilarang menulis kode.   │
└───────────────────────────────────────────┴────────────────────────────────────────────┘
```

> **Intervention Gate:** Setiap perintah yang dikirimkan wajib diawali kata kunci `dev` atau `skripsi`. Jika instruksi ambigu atau mencampuradukkan kedua domain, agen AI wajib menginterupsi dan meminta penegasan mode kerja.

---

## 2. Struktur Modular Repository

Repository ini disusun dengan tata letak modular untuk memudahkan portabilitas dan pemeliharaan:

```text
Model-Kerja-YOI/
├── README.md                           # Dokumentasi komprehensif pusat
├── CHANGELOG.md                        # Catatan riwayat versi sistem
├── LICENSE                             # Pernyataan lisensi penggunaan
├── .gitignore                          # Aturan pencegahan kebocoran secret & sampah
│
├── .github/
│   └── workflows/
│       └── template-ci.yml             # Template CI/CD GitHub Actions (Lint + Gitleaks)
│
├── core/                               # DOKTRIN & TATA KELOLA PUSAT
│   ├── MODEL_KERJA.md                  # Dokumen induk Standar Operasional Baku (SOP)
│   ├── PURSUIT_GOALS.template.md       # Template target capaian Goal A & Goal B
│   └── ETHICS_AND_COMPLIANCE.md        # Panduan etika AI, bebas plagiasi & Turnitin
│
├── agent-rules/                        # ATURAN PERILAKU NATIVE AI AGENT
│   ├── gemini/
│   │   └── mandatory_dual_mode.md      # Aturan native Antigravity/Gemini (.gemini/rules/)
│   ├── cursor/
│   │   └── .cursorrules                # Aturan native Cursor IDE
│   └── claude/
│       └── CLAUDE.md                   # Aturan native Claude Code CLI
│
├── devsecops/                          # ENGINE PEMERIKSA MUTU & KEAMANAN OTOMATIS
│   ├── quality_gate.ps1                # Skrip lokal PHP Lint + Gitleaks (Windows)
│   ├── quality_gate.sh                 # Skrip lokal PHP Lint + Gitleaks (Linux/macOS)
│   └── .gitleaks.toml                  # Konfigurasi pendeteksi kebocoran kredensial
│
├── monitoring/                         # SUBSISTEM PEMANTAUAN & UPDATE CONTINUOUS
│   ├── yoi_monitor.ps1                 # Utilitas CLI status, log aktivitas, & backlog
│   ├── activity_ledger.template.json   # Template database aktivitas berbasis JSON
│   └── ACTIVITY_TRACKER.template.md    # Template visual dashboard markdown
│
├── blueprints/                         # STANDAR ACUAN IMPLEMENTASI TEKNIS
│   ├── security/
│   │   ├── php/
│   │   │   ├── Csrf.php                # Modul backend proteksi CSRF (Timing-Safe)
│   │   │   ├── Origin.php              # Modul validasi Origin & Referer
│   │   │   └── RateLimiter.php         # Modul pembatasan laju request (Anti-Brute Force)
│   │   └── js/
│   │       └── csrf.js                 # Interceptor frontend Fetch API & Form HTML
│   └── templates/
│       └── raw_test_data/
│           └── LOG_BUKTI.template.md   # Template registri bukti empiris skripsi
│
├── scripts/
│   └── validation/
│       └── validate_repo.ps1           # Skrip pengujian integritas repository YOI
│
├── templates/                          # Direktori penyimpan template tambahan
├── install.ps1                         # INSTALLER RESMI WINDOWS POWERSHELL
└── install.sh                          # INSTALLER RESMI LINUX / MACOS
```

---

## 3. Panduan Instalasi ke Proyek Baru atau Proyek Berjalan

Sistem YOI menyediakan installer otomatis cerdas yang non-destruktif (tidak menghapus data pengguna) dan dilengkapi mekanisme pencadangan otomatis (*automatic backup*).

### A. Instalasi pada Windows (PowerShell)
Buka terminal PowerShell pada direktori proyek target Anda:

```powershell
# 1. Simulasi pemasangan (Dry Run) untuk memeriksa file yang akan dipasang
powershell -ExecutionPolicy Bypass -File "C:\Users\X1 Carbon\Model-Kerja-YOI\install.ps1" -TargetDir . -DryRun

# 2. Pemasangan penuh (Live Execution)
powershell -ExecutionPolicy Bypass -File "C:\Users\X1 Carbon\Model-Kerja-YOI\install.ps1" -TargetDir .
```

Opsi parameter yang didukung `install.ps1`:
* `-TargetDir <path>`: Direktori proyek tujuan (default: folder aktif).
* `-Component <All|Core|Rules|DevSecOps|Monitoring|Blueprints>`: Memasang hanya modul tertentu.
* `-DryRun`: Menjalankan simulasi tanpa mengubah file apa pun di disk.
* `-Force`: Menimpa berkas konfigurasi bawaan jika diperlukan.
* `-NoBackup`: Melewati pencadangan file lama (tidak disarankan).

### B. Instalasi pada Linux / macOS / WSL (Bash)
```bash
# 1. Simulasi pemasangan (Dry Run)
bash /path/to/Model-Kerja-YOI/install.sh . --dry-run

# 2. Pemasangan penuh
bash /path/to/Model-Kerja-YOI/install.sh .
```

---

## 4. Cara Menjalankan DevSecOps Quality Gate

Setiap kali sebelum melakukan commit kode di mode `dev`, jalankan pemeriksaan mutu lokal:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/quality_gate.ps1
```

Skrip ini akan memvalidasi secara deterministik:
1. **PHP Linting:** Memindai seluruh berkas PHP di `app/`, `public/`, `src/`, dan `config/` menggunakan `php -l`.
2. **Gitleaks Secret Scan:** Memindai seluruh proyek untuk mencegah kunci API atau kata sandi ter-commit.
3. **Composer Audit:** Memeriksa CVE pada dependensi pihak ketiga jika `composer.json` tersedia.
4. **Auto-Logging:** Menyimpan rekaman hasil audit secara otomatis ke `docs/raw_test_data/devsecops_audit_latest.txt` sebagai data bukti BAB IV skripsi.

---

## 5. Cara Menggunakan Sistem Monitoring Aktivitas

Sistem YOI menyediakan utilitas pemantauan untuk melacak kepatuhan, mencatat aktivitas harian, dan mengelola backlog pembaruan:

```powershell
# 1. Melihat status kepatuhan keamanan dan progres skripsi saat ini:
powershell -ExecutionPolicy Bypass -File scripts/yoi_monitor.ps1 -Status

# 2. Mencatat aktivitas yang baru saja diselesaikan:
powershell -ExecutionPolicy Bypass -File scripts/yoi_monitor.ps1 -Log -Mode dev -Task "Implementasi CSRF token pada API peta" -Artifact "app/Controllers/MapController.php"

# 3. Meninjau daftar rencana pembaruan berikutnya (Backlog):
powershell -ExecutionPolicy Bypass -File scripts/yoi_monitor.ps1 -Backlog
```

---

## 6. Standar Keamanan & Proteksi CSRF End-to-End

Seluruh proyek yang mengadopsi YOI diwajibkan menerapkan standar proteksi CSRF tersinkronisasi:
1. **Backend (`app/Security/Csrf.php`):** Token 32-byte acak diikat pada sesi ber-cookie `Strict` dan divalidasi dengan `hash_equals()`. Helper form tersedia via `Csrf::input()` dan helper meta tag via `Csrf::meta()`.
2. **Frontend (`public/assets/js/csrf.js`):** Interceptor otomatis mencegat seluruh request `fetch()` mutating (`POST`, `PUT`, `PATCH`, `DELETE`) dan menyematkan header `X-CSRF-Token`.
3. **Gateway Enforcement:** Front Controller memanggil `Csrf::verifyRequest()` sebelum rute controller dieksekusi.

---

## 7. Validasi Integritas Repository

Untuk memastikan repository pusat tetap bersih, valid, dan bebas dari kesalahan sintaks:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validation/validate_repo.ps1
```

Skrip validasi memeriksa:
* Kelengkapan 11 folder struktural wajib.
* Validitas sintaks seluruh skrip PowerShell menggunakan PowerShell AST Parser.
* Integritas dan validitas parsing seluruh file JSON.
* Pemindaian pencegahan file rahasia (`.env`, `*.key`, `*.pem`).
* Ketersediaan dokumen doktrin dan aturan wajib.

---

## 8. Sinkronisasi & Pembaruan ke GitHub

Repository ini terhubung secara resmi ke remote GitHub:
`https://github.com/syah663/Model-Kerja-YOI.git`

Pembaruan pada repository pusat ini dilakukan dengan siklus terkontrol:
1. Lakukan perubahan atau peningkatan pada template/skrip di repository pusat.
2. Jalankan `scripts/validation/validate_repo.ps1` untuk memastikan seluruh komponen lulus uji.
3. Buat commit Git lokal.
4. Lakukan sinkronisasi ke remote GitHub atas persetujuan pengguna.
5. Proyek-proyek hilir (*downstream*) dapat memperbarui versinya dengan menjalankan kembali `install.ps1`.
