import { defineConfig } from "@pandacss/dev";

export default defineConfig({
  preflight: true,
  include: ["./app/**/*.{ts,tsx,vue}"],
  exclude: [],
  outdir: "styled-system",
});
