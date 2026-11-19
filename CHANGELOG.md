# CATATAN PERUBAHAN (CHANGELOG) SISTEM YOI

Seluruh perubahan dan pembaruan arsitektur model kerja AI YOI dicatat secara berkesinambungan di bawah ini:

---

## [v4.0.0] - 2026-11-19
### Rilis: Repository Pusat Model-Kerja-YOI & AG v2.1
- **Inisialisasi Pusat:** Pembentukan repository terpusat `Model-Kerja-YOI` di GitHub (`https://github.com/syah663/Model-Kerja-YOI.git`).
- **Pemisahan Modular:** Isolasi komponen tata kelola dari kode spesifik aplikasi ke dalam folder `core/`, `agent-rules/`, `devsecops/`, `monitoring/`, dan `blueprints/`.
- **Installer Otomatis:** Pembuatan `install.ps1` dan `install.sh` dengan dukungan simulasi (Dry Run), pencadangan otomatis (Auto-Backup), dan seleksi komponen.
- **Engine Validasi Mandiri:** Pembuatan `scripts/validation/validate_repo.ps1` untuk memverifikasi sintaks AST PowerShell, format JSON, dan pemeriksaan rahasia.
- **Pedoman Etika & Kepatuhan:** Penambahan `core/ETHICS_AND_COMPLIANCE.md` untuk panduan bebas plagiasi, anti-halusinasi data, dan kepatuhan Turnitin.

---

## [v3.0.0] - 2026-11-11
### Peningkatan: Mandatori Universal (Zero-Bypass Policy) & CSRF
- **Tata Kelola Mandatori:** Penetapan nama sistem resmi **YOI** dan identitas mesin **AG v2.1**.
- **Penyederhanaan Mode:** Pilihan mode kerja disederhanakan menjadi dua kata kunci langsung: `dev` (Software Development) dan `skripsi` (Riset Skripsi S1).
- **Intervention Gate:** Penolakan dan interupsi otomatis jika prompt tidak mencantumkan mode kerja atau mencampurkan dua domain.
- **Proteksi CSRF Penuh:** Integrasi backend `Csrf.php` (token kriptografis 32-byte, `hash_equals`) dan frontend `csrf.js` (Fetch interceptor & form auto-injector).
- **Sistem Monitoring Terpadu:** Pembuatan `docs/monitoring/activity_ledger.json`, `ACTIVITY_TRACKER.md`, dan CLI `yoi_monitor.ps1`.

---

## [v2.0.0] - 2026-11-11
### Peningkatan: DevSecOps Gate & Evaluator-Optimizer Loop
- **Adopsi DevSecOps Terarah:** Integrasi PHP Syntax Linting (`php -l`), Gitleaks Secret Detection, dan Composer Audit melalui `quality_gate.ps1` dan CI/CD GitHub Actions (`.github/workflows/ci.yml`).
- **Evaluator-Optimizer Loop:** Penerapan siklus audit mandiri internal agen AI sebelum menyajikan kode kepada mahasiswa.
- **Dual-Purpose Evidence:** Log hasil pengujian mutu otomatis disimpan ke `docs/raw_test_data/` sebagai data empiris pendukung BAB IV skripsi.

---

## [v1.0.0] - 2026-11-10
### Rilis Awal: Fondasi Dual-Mode
- **Pemisahan Konteks:** Transformasi dari alur kerja bercampur menjadi dua mode terisolasi (Jalur A Rekayasa Sistem vs Jalur B Skripsi Ilmiah).
- **Doktrin Awal:** Penyusunan draf awal `MODEL_KERJA.md` dan matriks target capaian `PURSUIT_GOALS.md`.
