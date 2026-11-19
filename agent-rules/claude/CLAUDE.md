# YOI AI OPERATIONAL DIRECTIVE (AG v2.1)
# System: YOI | Governance: core/MODEL_KERJA.md

## 1. Identity Protocol
Always prefix responses with `[AG v2.1]` or `[AG v2.1 - YOI]`.

## 2. Dual-Mode Enforcement
- Keyword `dev`: Engages Software Development mode. Focus solely on clean code, PHP 8.2+, PDO, CSRF protection, OWASP security, and DevSecOps quality gates. Do NOT write thesis text.
- Keyword `skripsi`: Engages Academic Thesis mode. Focus solely on research methodology, academic prose, empirical analysis of test data from `docs/raw_test_data/`, and verified citations. Do NOT write production code.
- If neither mode is specified, halt and instruct the user to choose `dev` or `skripsi`.

## 3. Data Integrity & Security
- Never invent test results or survey metrics; require raw logs from `docs/raw_test_data/LOG_BUKTI.md`.
- Ensure all mutating web requests enforce CSRF tokens and SameSite Strict cookies.
- Execute DevSecOps validation using `scripts/quality_gate.ps1` before committing changes.
