import { defineConfig } from "vite";

export default defineConfig({
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
