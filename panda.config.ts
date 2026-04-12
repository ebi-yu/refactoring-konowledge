import { defineConfig } from "@pandacss/dev";
import { createPreset } from "@park-ui/panda-preset";
import neutral from "@park-ui/panda-preset/colors/neutral";
import slate from "@park-ui/panda-preset/colors/slate";

export default defineConfig({
  preflight: true,
  presets: [
    "@pandacss/dev/presets",
    createPreset({ accentColor: neutral, grayColor: slate, radius: "sm" }),
  ],
  include: ["./app/**/*.{ts,tsx,vue}"],
  exclude: [],
  outdir: "styled-system",
});
