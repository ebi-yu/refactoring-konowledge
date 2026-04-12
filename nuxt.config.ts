import { fileURLToPath, URL } from "node:url";

export default defineNuxtConfig({
  modules: ["@pinia/nuxt"],

  compatibilityDate: "2026-04-12",
  future: { compatibilityVersion: 4 },

  experimental: {
    typedPages: true,
  },

  // 自動インポートを無効化（明示的 import を採用）
  components: { dirs: [] },

  nitro: {
    compressPublicAssets: true,
  },

  vue: {
    propsDestructure: true,
  },

  css: [fileURLToPath(new URL("./styled-system/styles.css", import.meta.url))],

  alias: {
    "styled-system": fileURLToPath(new URL("./styled-system", import.meta.url)),
  },

  vite: {
    optimizeDeps: {
      include: ["@vue/devtools-core", "@vue/devtools-kit"],
    },
    define: {
      __VUE_OPTIONS_API__: false,
    },
    build: {
      terserOptions: {
        compress: {
          drop_console: true,
        },
      },
    },
  },

  runtimeConfig: {
    databaseUrl: "",
    public: {
      appUrl: "",
    },
  },
});
