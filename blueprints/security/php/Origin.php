<?php
declare(strict_types=1);

namespace App\Security;

/**
 * Blueprint Keamanan YOI - Validasi Origin & Referer
 * Identitas Mesin: AG v2.1 | Sistem: YOI
 * 
 * Standar: OWASP Cross-Site Request Defense
 * Memastikan setiap request mutating berasal dari domain yang diizinkan.
 */
class Origin
{
    public static function verify(): void
    {
        $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
        if (in_array(strtoupper($method), ['POST', 'PUT', 'PATCH', 'DELETE'], true)) {
            $origin = $_SERVER['HTTP_ORIGIN'] ?? null;
            $referer = $_SERVER['HTTP_REFERER'] ?? null;
            $host = $_SERVER['HTTP_HOST'] ?? 'localhost';

            if ($origin !== null) {
                $originHost = parse_url($origin, PHP_URL_HOST);
                $serverHost = explode(':', $host)[0];

                if ($originHost !== $serverHost && $originHost !== 'localhost' && $originHost !== '127.0.0.1') {
                    http_response_code(403);
                    header('Content-Type: application/json; charset=UTF-8');
                    echo json_encode([
                        'success' => false,
                        'error' => 'INVALID_ORIGIN',
                        'message' => 'Permintaan dari origin tidak dikenal diblokir oleh sistem keamanan.'
                    ], JSON_UNESCAPED_UNICODE);
                    exit;
                }
            }
        }
    }
}
