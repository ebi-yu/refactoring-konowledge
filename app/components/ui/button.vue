<script setup lang="ts">
import { ark } from "@ark-ui/vue/factory";
import { sva } from "styled-system/css";

const buttonRecipe = sva({
  slots: ["root"],
  base: {
    root: {
      display: "inline-flex",
      alignItems: "center",
      justifyContent: "center",
      gap: "2",
      fontWeight: "semibold",
      borderRadius: "sm",
      cursor: "pointer",
      transitionProperty: "background, border-color, color, box-shadow",
      transitionDuration: "normal",
      _disabled: { opacity: "0.4", cursor: "not-allowed" },
      _focusVisible: {
        outline: "2px solid",
        outlineColor: "neutral.8",
        outlineOffset: "2px",
      },
    },
  },
  variants: {
    variant: {
      solid: {
        root: {
          bg: "neutral.9",
          color: "white",
          _hover: { bg: "neutral.10" },
        },
      },
      outline: {
        root: {
          borderWidth: "1px",
          borderColor: "neutral.9",
          color: "neutral.11",
          _hover: { bg: "neutral.2" },
        },
      },
      ghost: {
        root: {
          color: "neutral.11",
          _hover: { bg: "neutral.3" },
        },
      },
    },
    size: {
      sm: { root: { h: "8", px: "3", textStyle: "sm" } },
      md: { root: { h: "10", px: "4", textStyle: "sm" } },
      lg: { root: { h: "11", px: "6", textStyle: "md" } },
    },
  },
  defaultVariants: {
    variant: "solid",
    size: "md",
  },
});

interface Props {
  variant?: "solid" | "outline" | "ghost";
  size?: "sm" | "md" | "lg";
  disabled?: boolean;
}

const { variant, size, disabled } = defineProps<Props>();
const classes = buttonRecipe({ variant, size });
</script>

<template>
  <ark.button :class="classes.root" :disabled="disabled">
    <slot />
  </ark.button>
</template>
