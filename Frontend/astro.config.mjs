// @ts-check
import { defineConfig } from 'astro/config';
const apiUrl = typeof process !== 'undefined' && process.env.PUBLIC_API_URL
               ? process.env.PUBLIC_API_URL
               : import.meta.env.PUBLIC_API_URL;

// https://astro.build/config
export default defineConfig({
    devToolbar: {
        enabled: false
    },
    vite: {
        server: {
            host: true,
            port: 3000,
            allowedHosts: ['*'],
            proxy: {
                '/api': {
                    target: apiUrl,
                    changeOrigin: true,
                }
            }
        }
    }
});

// // @ts-check
// import { defineConfig } from 'astro/config';
// import node from '@astrojs/node';

// const apiUrl = typeof process !== 'undefined' && process.env.PUBLIC_API_URL
//                ? process.env.PUBLIC_API_URL
//                : import.meta.env.PUBLIC_API_URL;

// // https://astro.build/config
// export default defineConfig({
//     output: 'server',
//     adapter: node({ mode: 'standalone' }),
//     vite: {
//         server: {
//             host: true,
//             port: 3000,
//             allowedHosts: ['*'],
//             proxy: {
//                 '/api': {
//                     target: apiUrl,
//                     changeOrigin: true
//                 }
//             }
//         }
//     }
// });