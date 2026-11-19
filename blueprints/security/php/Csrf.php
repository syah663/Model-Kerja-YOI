<?php
declare(strict_types=1);

namespace App\Security;

/**
 * Blueprint Keamanan YOI - Modul Proteksi CSRF
 * Identitas Mesin: AG v2.1 | Sistem: YOI
 * 
 * Standar: OWASP Top 10 A01:2021-Broken Access Control / CSRF
 * Fitur:
 * - Pembangkitan token 32-byte kriptografis aman (random_bytes)
 * - Validasi timing-safe menggunakan hash_equals
 * - Dukungan form input hidden & meta tag
 * - Verifikasi otomatis request mutating (POST, PUT, PATCH, DELETE)
 */
class Csrf
{
    private const SESSION_KEY = '_csrf_token';

    public static function initSession(): void
    {
        if (session_status() === PHP_SESSION_NONE) {
            $isHttps = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') ||
                       (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https');

            session_set_cookie_params([
                'lifetime' => (int)(getenv('SESSION_LIFETIME') ?: 7200),
                'path' => '/',
                'domain' => '',
                'secure' => $isHttps,
                'httponly' => true,
                'samesite' => 'Strict'
            ]);
            session_start();
        }
    }

    public static function getToken(): string
    {
        self::initSession();
        if (empty($_SESSION[self::SESSION_KEY])) {
            $_SESSION[self::SESSION_KEY] = bin2hex(random_bytes(32));
        }
        return $_SESSION[self::SESSION_KEY];
    }

    public static function input(): string
    {
        $token = htmlspecialchars(self::getToken(), ENT_QUOTES, 'UTF-8');
        return '<input type="hidden" name="_csrf_token" value="' . $token . '">';
    }

    public static function meta(): string
    {
        $token = htmlspecialchars(self::getToken(), ENT_QUOTES, 'UTF-8');
        return '<meta name="csrf-token" content="' . $token . '">';
    }

    public static function validate(?string $token): bool
    {
        self::initSession();
        if (empty($_SESSION[self::SESSION_KEY]) || empty($token)) {
            return false;
        }
        return hash_equals($_SESSION[self::SESSION_KEY], $token);
    }

    public static function verifyRequest(): void
    {
        $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
        if (in_array(strtoupper($method), ['POST', 'PUT', 'PATCH', 'DELETE'], true)) {
            $headers = function_exists('getallheaders') ? getallheaders() : [];
            $token = $headers['X-CSRF-Token'] ?? $headers['x-csrf-token'] ?? null;

            if (!$token) {
                $raw = file_get_contents('php://input');
                $json = json_decode($raw, true);
                $token = $json['_csrf_token'] ?? $_POST['_csrf_token'] ?? null;
            }

            if (!self::validate($token)) {
                http_response_code(403);
                header('Content-Type: application/json; charset=UTF-8');
                echo json_encode([
                    'success' => false,
                    'error' => 'CSRF_INVALID',
                    'message' => 'Token proteksi CSRF tidak valid atau telah kedaluwarsa.'
                ], JSON_UNESCAPED_UNICODE);
                exit;
            }
        }
    }
}
