<?php
declare(strict_types=1);

namespace App\Security;

/**
 * Blueprint Keamanan YOI - Rate Limiting & Proteksi Brute-Force
 * Identitas Mesin: AG v2.1 | Sistem: YOI
 * 
 * Standar: OWASP Automated Threat Mitigation / Anti Brute-Force
 * Menyediakan pembatasan request per IP menggunakan file storage.
 */
class RateLimiter
{
    private static string $storageDir = '';

    private static function getStorageDir(): string
    {
        if (self::$storageDir === '') {
            $baseDir = dirname(__DIR__, 2);
            self::$storageDir = $baseDir . '/storage/logs/ratelimit';
            if (!is_dir(self::$storageDir)) {
                mkdir(self::$storageDir, 0755, true);
            }
        }
        return self::$storageDir;
    }

    public static function check(string $key, int $maxRequests = 60, int $decaySeconds = 60): bool
    {
        $ip = $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
        $hash = md5($key . '_' . $ip);
        $file = self::getStorageDir() . '/' . $hash . '.json';

        $now = time();
        $data = ['hits' => 0, 'reset' => $now + $decaySeconds];

        if (file_exists($file)) {
            $raw = file_get_contents($file);
            $parsed = json_decode($raw, true);
            if ($parsed && isset($parsed['reset']) && $parsed['reset'] > $now) {
                $data = $parsed;
            }
        }

        $data['hits']++;
        file_put_contents($file, json_encode($data), LOCK_EX);

        if ($data['hits'] > $maxRequests) {
            header('Retry-After: ' . ($data['reset'] - $now));
            http_response_code(429);
            header('Content-Type: application/json; charset=UTF-8');
            echo json_encode([
                'success' => false,
                'error' => 'RATE_LIMIT_EXCEEDED',
                'message' => 'Terlalu banyak permintaan dalam waktu singkat. Silakan tunggu beberapa saat.'
            ], JSON_UNESCAPED_UNICODE);
            exit;
        }

        return true;
    }
}
