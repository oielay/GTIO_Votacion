import { defineConfig } from "vite";

export default defineConfig({
//   server: {
//     allowedHosts: true, //[process.env.PUBLIC_API_URL]
//     host: '0.0.0.0',
//     port: 3000,
//   },
  test: {
    environment: "jsdom",
    globals: true,
    setupFiles: "./vitest.setup.ts",
    include: [
      "tests/**/*.{test,spec}.{js,ts}",
      "**/?(*.)+(spec|test).[tj]s?(x)",
    ],
    transformMode: {
      web: [/.[jt]sx?/],
    },
  },
});
