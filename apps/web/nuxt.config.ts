// https://nuxt.com/docs/api/configuration/nuxt-config
import tailwindcss from "@tailwindcss/vite"

export default defineNuxtConfig({
  compatibilityDate: '2026-09-01',
  devtools: { enabled: true },
  modules: [
    "@pinia/nuxt",
    "@nuxtjs/i18n"
  ],
  css: ["@/assets/css/main.css"],
  vite: { plugins: [tailwindcss()] },
  vue: {
    compilerOptions: { isCustomElement: (tag) => tag == "altcha-widget" },
  },
  i18n: {
    locales: [{ code: "es", language: "es-MX", file: "es.json" }],
    defaultLocale: "es",
    langDir: "locales",
  },
  runtimeConfig: {
    apiInternalBase: "http://localhost:3000",
    public: { apiBase: "/api" }
  },
  nitro: {
    devProxy: {
      "/api": {
        target: "http://localhost:3000/api",
        changeOrigin: true,
        ws: true
      }
    }
  }
})
