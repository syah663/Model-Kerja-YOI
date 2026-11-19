/**
 * Blueprint Keamanan YOI - CSRF Frontend Interceptor
 * Identitas Mesin: AG v2.1 | Sistem: YOI
 * 
 * Modul otomatis untuk:
 * 1. Mencegat seluruh fetch() mutating (POST, PUT, PATCH, DELETE) dan menyuntikkan header 'X-CSRF-Token'.
 * 2. Menyuntikkan input hidden '_csrf_token' pada seluruh form HTML secara dinamis.
 */

(function () {
    'use strict';

    function getCsrfToken() {
        const meta = document.querySelector('meta[name="csrf-token"]');
        return meta ? meta.getAttribute('content') : '';
    }

    // 1. Fetch API Interceptor
    const originalFetch = window.fetch;
    window.fetch = async function (resource, options = {}) {
        const method = (options.method || 'GET').toUpperCase();
        const mutatingMethods = ['POST', 'PUT', 'PATCH', 'DELETE'];

        if (mutatingMethods.includes(method)) {
            options.headers = options.headers || {};
            const token = getCsrfToken();

            if (token) {
                if (options.headers instanceof Headers) {
                    if (!options.headers.has('X-CSRF-Token')) {
                        options.headers.append('X-CSRF-Token', token);
                    }
                } else if (Array.isArray(options.headers)) {
                    options.headers.push(['X-CSRF-Token', token]);
                } else {
                    options.headers['X-CSRF-Token'] = options.headers['X-CSRF-Token'] || token;
                }
            }
        }

        return originalFetch(resource, options);
    };

    // 2. Form Auto-Injector
    function injectCsrfToForms() {
        const token = getCsrfToken();
        if (!token) return;

        document.querySelectorAll('form').forEach(form => {
            const method = (form.getAttribute('method') || 'GET').toUpperCase();
            if (method !== 'GET' && !form.querySelector('input[name="_csrf_token"]')) {
                const hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = '_csrf_token';
                hiddenInput.value = token;
                form.appendChild(hiddenInput);
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', injectCsrfToForms);
    } else {
        injectCsrfToForms();
    }

    // Expose utility ke window.YOI_CSRF
    window.YOI_CSRF = {
        getToken: getCsrfToken,
        refresh: async function (csrfEndpoint = '/api/auth/csrf') {
            try {
                const res = await originalFetch(csrfEndpoint);
                const data = await res.json();
                if (data.token) {
                    let meta = document.querySelector('meta[name="csrf-token"]');
                    if (!meta) {
                        meta = document.createElement('meta');
                        meta.name = 'csrf-token';
                        document.head.appendChild(meta);
                    }
                    meta.setAttribute('content', data.token);
                    injectCsrfToForms();
                }
            } catch (err) {
                console.error('[AG v2.1] [YOI] Gagal me-refresh token CSRF:', err);
            }
        }
    };
})();
