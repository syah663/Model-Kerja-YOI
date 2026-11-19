# PURSUIT GOALS: [NAMA_PROYEK] & SKRIPSI S1
**Sistem:** YOI  
**Identitas Mesin:** AG v2.1  
**Versi:** 2.1 (Template Portabel)  
**Entitas Proyek:** [Nama Sistem Perangkat Lunak / Studi Kasus] & Naskah Skripsi S1  
**Instruksi Kerja:** `dev` (Software Development) | `skripsi` (Aktivitas Skripsi)  
**Sistem Monitoring:** [docs/monitoring/ACTIVITY_TRACKER.md](./docs/monitoring/ACTIVITY_TRACKER.md)

---

## 1. Definisi Pursuit Goals

Pursuit Goals adalah dua target puncak yang tidak dapat ditawar. Seluruh alokasi waktu, baris kode, dan penulisan naskah hanya sah jika berkontribusi langsung pada salah satu dari dua sasaran ini:

```
                          ┌───────────────────────────────────────────────┐
                          │             PURSUIT GOALS PUSAT               │
                          └──────┬─────────────────────────────────┬──────┘
                                 │                                 │
                 ┌───────────────▼───────────────┐ ┌───────────────▼───────────────┐
                 │        PURSUIT GOAL A         │ │        PURSUIT GOAL B         │
                 │   [SISTEM & ENGINEERING]      │ │    [AKADEMIK & SKRIPSI S1]    │
                 │   Sistem [NAMA_PROYEK]        │ │   Naskah Skripsi Ilmiah       │
                 │   Aman, Cepat, Teruji         │ │   Empiris, Sahih, Lulus A     │
                 └───────────────────────────────┘ └───────────────────────────────┘
```

---

## 2. Rincian Sasaran & Metrik Ketercapaian

### A. Pursuit Goal A: Rekayasa Sistem (Software Development)
Membangun dan meluncurkan sistem perangkat lunak yang aman, berkinerja tinggi, dan siap digunakan sesuai spesifikasi kebutuhan:

* **Target Kunci 1: Keamanan Berlapis (OWASP Compliance)**
  - 100% bebas dari kerentanan kritis dan tinggi pada pengujian dinamis (DAST) OWASP ZAP dan pemindaian injeksi sqlmap.
  - Penerapan proteksi: PDO Prepared Statements (native), Anti-CSRF token per sesi, SameSite Strict cookies (`Secure`, `HttpOnly`), Validasi Origin/Referer, Header Keamanan HTTP (CSP, HSTS, X-Frame-Options, X-Content-Type-Options), Rate Limiting, dan Re-autentikasi aksi sensitif.
* **Target Kunci 2: Arsitektur & Basis Data**
  - Desain basis data normalisasi 3NF, integritas kunci asing (*foreign keys*), indeks query efisien, dan waktu respon query < [TARGET_MS] ms.
* **Target Kunci 3: Kesiapan Rilis & Aksesibilitas (PWA / Web)**
  - Skor Google Lighthouse: PWA/Best Practices ≥ 90%, Performance ≥ 85%, Accessibility ≥ 90%.
  - Dukungan navigasi offline dasar (*offline fallback* via Service Worker) jika menggunakan arsitektur PWA.

---

### B. Pursuit Goal B: Riset Ilmiah & Penyusunan Skripsi S1
Menyusun naskah skripsi komprehensif, berbasis data empiris terukur, bebas fabrikasi/halusinasi, serta siap dipertanggungjawabkan di hadapan dewan penguji:

* **Target Kunci 1: Keselarasan Ilmiah 100% (Alignment Matrix)**
  - Rumusan Masalah, Tujuan Penelitian, Metrik Pengujian di Bab III, Hasil Pengujian di Bab IV, dan Kesimpulan di Bab V saling mengunci tanpa diskrepansi logika.
* **Target Kunci 2: Pembuktian Empiris Kuantitatif**
  - Data pengujian keamanan nyata: Perbandingan kuantitatif kondisi *Sebelum Hardening* vs *Setelah Hardening* (*Vulnerability Mitigation Rate* 100%).
  - Data pengujian kinerja & beban: Grafik throughput (req/sec) dan waktu respon menggunakan alat uji beban (k6 / Apache Bench).
  - Data pengujian usabilitas: Evaluasi SUS (*System Usability Scale*) dengan target skor rata-rata > 70 (*Acceptable / Good*).
* **Target Kunci 3: Integritas Akademik & Ketertelusuran**
  - Tingkat kemiripan (Turnitin) di bawah batas toleransi kampus (< 20%).
  - Seluruh referensi primer (jurnal bereputasi/prosiding) terverifikasi keberadaannya via DOI dan tersimpan di Zotero/Mendeley.
  - Log penggunaan AI transparan dan siap dipertanggungjawabkan.

---

## 3. Matriks Keterlacakan (Traceability Matrix)

| Komponen Sistem (Goal A) | Bukti Pengujian Teknis | Bab Terkait di Skripsi (Goal B) | Indikator Keberhasilan Skripsi |
| :--- | :--- | :--- | :--- |
| **Fitur Fungsional Utama** | Benchmark query time, log pengujian fitur | **BAB I, BAB III, BAB IV** (Perancangan & Implementasi) | Validitas fungsional fitur terbukti |
| **Modul Keamanan (Anti-SQLi, CSRF, CSP)** | Log eksekusi sqlmap, Burp Suite, OWASP ZAP | **BAB IV** (Hasil Uji Keamanan Sebelum vs Sesudah) | Penurunan kerentanan terbukti secara statistik |
| **Service Worker & Manifest PWA** | Audit report Lighthouse Chrome DevTools | **BAB IV** (Analisis Kesiapan PWA & Aksesibilitas) | Skor Lighthouse memenuhi standar industri |
| **Antarmuka Pengguna & Alur UX** | Rekap kuesioner SUS responden nyata | **BAB IV** (Evaluasi Usabilitas Sistem) | Rata-rata skor SUS > 70 terhitung matematis |
| **Arsitektur Sistem Menyeluruh** | Diagram arsitektur, DDL, flowchart | **BAB III & BAB V** (Metodologi & Kesimpulan) | Menjawab rumusan masalah sistemik |
