# PEDOMAN ETIKA PENGGUNAAN AI & KEPATUHAN AKADEMIK
**Sistem:** YOI  
**Identitas Mesin:** AG v2.1  
**Status:** Wajib Dipatuhi oleh Mahasiswa Pengguna Model Kerja YOI

---

## 1. Kedudukan AI dalam Penelitian Skripsi

Dalam kerangka kerja YOI, kecerdasan buatan (AI) diposisikan secara tegas sebagai **asisten analisis, pengkritik logika, dan akselerator teknis**, bukan pengganti integritas intelektual mahasiswa:

* **Mahasiswa adalah Penanggung Jawab Penuh:** Seluruh naskah, argumen, kesimpulan, dan baris kode adalah tanggung jawab mahasiswa di hadapan dosen pembimbing dan dewan penguji.
* **Bukan Ghostwriter:** AI dilarang digunakan untuk mengarang naskah secara buta (*ghostwriting*). Naskah skripsi harus dirumuskan dari pemahaman dan analisis mahasiswa sendiri.
* **Bukan Sumber Primer Kebenaran:** AI tidak memiliki otoritas ilmiah. Seluruh klaim teoretis wajib dirujuk dari pustaka ilmiah resmi yang telah diverifikasi langsung oleh mahasiswa.

---

## 2. Standar Integritas Akademik & Anti-Plagiarisme

### A. Larangan Halusinasi & Fabrikasi Data
* **Data Pengujian (BAB IV):** Seluruh angka pengujian (persentase kerentanan, waktu respon latensi, skor SUS, hasil pemindaian ZAP/sqlmap) wajib bersumber dari eksekusi nyata yang tercatat di folder `docs/raw_test_data/`. Dilarang meminta AI mengarang atau menyimulasikan angka hasil uji seolah-olah data nyata.
* **Referensi & Sitasi (BAB II):** Setiap rujukan jurnal atau buku wajib diverifikasi keberadaannya via tautan DOI (*Digital Object Identifier*) atau indeks Scopus/Sinta/Google Scholar resmi. AI dilarang menghasilkan referensi fiktif.

### B. Pengendalian Kemiripan (*Similarity Rate* / Turnitin)
* Mahasiswa wajib menggunakan gaya bahasa ilmiah aktif-pasif objektif dengan pemikiran sendiri.
* AI dapat digunakan untuk memparafrase dan mengkritik kohesi antar-paragraf, namun substansi ide tetap berasal dari pemikiran mahasiswa.
* Target ambang batas kemiripan Turnitin adalah **< 20%** (atau sesuai regulasi program studi masing-masing).

---

## 3. Dokumentasi & Transparansi Penggunaan AI (Audit Trail)

Untuk memenuhi prinsip transparansi akademik, seluruh aktivitas perancangan dan penulisan yang melibatkan asisten AI wajib tercatat dalam log pemantauan sistem YOI:

1. **Activity Ledger:** Menggunakan berkas `docs/monitoring/activity_ledger.json` untuk mencatat waktu, mode, dan deskripsi tugas yang dibantu oleh AI.
2. **Lampiran Naskah Skripsi:** Jika disyaratkan oleh perguruan tinggi, mahasiswa dapat mengekstrak tabel riwayat dari `docs/monitoring/ACTIVITY_TRACKER.md` sebagai lampiran resmi mengenai pernyataan kejujuran dan keterbukaan penggunaan alat bantu AI.

---

## 4. Perlindungan Kerahasiaan Data (*Data Privacy*)

* **Data Sensitif Studi Kasus:** Dilarang mengunggah informasi rahasia, data kependudukan pribadi (PII), kredensial server produksi, atau kunci API ke dalam percakapan AI.
* **Gunakan Data Contoh (Dummy Data):** Seluruh perancangan skema database, pengujian API, dan skenario simulasi wajib menggunakan data sampel fiktif yang tidak melanggar privasi instansi atau responden.
