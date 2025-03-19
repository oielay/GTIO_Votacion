// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
    devToolbar: {
        enabled: false
    },
    vite: {
        server: {
            proxy: {
                '/api': {
                    target: 'http://api_candidatos:8080',
                    changeOrigin: true,
                }
            }
        }
    }
});