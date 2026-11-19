# LOG ARTEFAK PENGUJIAN MENTAH (HANDOFF EVIDENCE)
**Sistem:** YOI  
**Identitas Mesin:** AG v2.1  
**Proyek:** [NAMA_PROYEK] & Skripsi S1  
**Fungsi:** Menyimpan jejak pengujian teknis dari Mode Dev untuk diolah menjadi data ilmiah di Mode Skripsi.

| ID Uji | Tanggal | Modul / Aspek | Alat Uji | Berkas Bukti Mentah di Folder Ini | Ringkasan Temuan Teknis | Status Hardening |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| UJI-01 | YYYY-MM-DD | SQL Injection Parameter | sqlmap / payload | `sqlmap_test_results.txt` | Target: 0 kerentanan pada query PDO | [DIRENCANAKAN] |
| UJI-02 | YYYY-MM-DD | Audit Kerentanan Web | OWASP ZAP (Active Scan) | `zap_scan_report.json` | Baseline scan awal vs scan akhir | [DIRENCANAKAN] |
| UJI-03 | YYYY-MM-DD | Audit Kesiapan PWA/Web | Chrome Lighthouse | `lighthouse_audit.html` | Target PWA = 100, Perf ≥ 85 | [DIRENCANAKAN] |
| UJI-04 | YYYY-MM-DD | Uji Beban Konkurensi | k6 / Apache Bench | `k6_benchmark_results.json` | Pengujian latensi request API | [DIRENCANAKAN] |
| UJI-05 | YYYY-MM-DD | Usabilitas Pengguna | Kuesioner SUS (10 Butir) | `sus_survey_responses.csv` | Target skor rata-rata SUS > 70 | [DIRENCANAKAN] |
