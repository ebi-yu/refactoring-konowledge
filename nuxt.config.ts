export default defineNuxtConfig({
  future: { compatibilityVersion: 4 },

  experimental: {
    typedPages: true,
  },

  // 自動インポートを無効化（明示的 import を採用）
  imports: { autoImport: false },
  components: { dirs: [] },

  nitro: {
    compressPublicAssets: true,
  },

  vue: {
    propsDestructure: true,
    defineModel: true,
    features: {
      optionsAPI: false,
    },
  },

  vite: {
    build: {
      terserOptions: {
        compress: {
          drop_console: true,
        },
      },
    },
  },

  runtimeConfig: {
    databaseUrl: '',
    public: {
      appUrl: '',
    },
  },
})
