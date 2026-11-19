# DASHBOARD MONITORING AKTIVITAS SISTEM YOI
**Sistem:** YOI (Tata Kelola Terpadu Rekayasa Perangkat Lunak & Skripsi S1)  
**Identitas Mesin:** AG v2.1  
**Proyek:** [NAMA_PROYEK] & Skripsi S1  
**Terakhir Diperbarui:** [TANGGAL_UPDATE]

---

## 1. STATUS MONITORING KEPATUHAN & KEAMANAN

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                    KARTU KENDALI MONITORING YOI                              │
├────────────────────────────┬─────────────────────────────┬───────────────────┤
│ Aspek Evaluasi             │ Status Implementasi         │ Bukti Terverifikasi│
├────────────────────────────┼─────────────────────────────┼───────────────────┤
│ Mode Kerja Aktif           │ [dev] / [skripsi]           │ Terpilih per Sesi │
│ Proteksi CSRF (OWASP)      │ KONFIGURASI / AKTIF         │ app/Security/Csrf │
│ Proteksi SQL Injection     │ AKTIF (PDO Native Prepared) │ app/Models/       │
│ Proteksi XSS & CSP         │ AKTIF (htmlspecialchars)    │ app/Views/        │
│ DevSecOps Quality Gate     │ AKTIF (PHP Lint + Gitleaks) │ scripts/quality_g │
│ Kesiapan Aksesibilitas     │ AKTIF (Lighthouse Target)   │ public/sw.js      │
│ Integrasi Skripsi Bab IV   │ HANDOFF TERHUBUNG           │ docs/raw_test_data│
└────────────────────────────┴─────────────────────────────┴───────────────────┘
```

---

## 2. STANDAR KEAMANAN SOFTWARE DEV (DILENGKAPI CSRF)

Sistem YOI mewajibkan seluruh pengkodean perangkat lunak di mode `dev` mematuhi standar keamanan:

### A. Mekanisme Proteksi CSRF
1. **Token Cryptographically Secure:** Dihasilkan via `random_bytes(32)` dan disimpan dalam sesi berotentikasi.
2. **Validasi Timing-Safe:** Menggunakan `hash_equals()` untuk mencegah *timing attacks*.
3. **Penyematan di Sisi Klien:**
   - **Form HTML:** `<input type="hidden" name="_csrf_token" value="<?= \App\Security\Csrf::getToken() ?>">`
   - **Single Page App / PWA:** Disematkan di `<meta name="csrf-token" content="<?= \App\Security\Csrf::getToken() ?>">`
   - **AJAX / Fetch API:** Diinjeksi otomatis pada header HTTP `X-CSRF-Token` di setiap request mutating (`POST`, `PUT`, `PATCH`, `DELETE`).
4. **Verifikasi Terpusat:** Diperiksa otomatis di `Csrf::verifyRequest()` pada Front Controller sebelum route dieksekusi. Request tanpa token valid langsung ditolak dengan HTTP 403 Forbidden.

### B. Standar OWASP Lengkap yang Mengikat
* **SQL Injection:** Wajib 100% menggunakan PDO Prepared Statements tanpa emulasi (`PDO::ATTR_EMULATE_PREPARES => false`).
* **Cross-Site Scripting (XSS):** Wajib sanitasi seluruh output ke antarmuka menggunakan `htmlspecialchars($var, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8')` ditambah header Content-Security-Policy (CSP).
* **Session Hijacking:** Cookie berkonfigurasi `Secure`, `HttpOnly`, `SameSite=Strict`, dan `session_regenerate_id(true)` saat login.
* **Origin/Referer Validation:** Memastikan request mutating berasal dari domain aplikasi sendiri.
* **Brute-Force & Rate Limiting:** Pembatasan percobaan login melalui `RateLimiter.php`.

---

## 3. LOG AKTIVITAS HISTORIS (ACTIVITY LEDGER)

Setiap aktivitas dicatat untuk menjamin auditabilitas dan memudahkan penyusunan naskah skripsi:

| ID Aktivitas | Waktu | Mode | Pelaksana | Tugas yang Diselesaikan | Artefak / Berkas | Status |
| :--- | :--- | :---: | :--- | :--- | :--- | :---: |
| **ACT-001** | YYYY-MM-DD HH:mm | `system` | Mahasiswa & AG | Inisialisasi tata kelola sistem YOI AG v2.1 | `MODEL_KERJA.md` | SUCCESS |

---

## 4. BACKLOG UPDATE & PEMBAHARUAN BERIKUTNYA

Daftar target peningkatan berikutnya yang dapat dimonitor dan dieksekusi berkala:

- [ ] **UPD-001 (dev):** Verifikasi integrasi token CSRF pada seluruh fetch API mutating.
- [ ] **UPD-002 (skripsi):** Penyusunan draf Bab III & Bab IV terkait metodologi pengujian keamanan.
