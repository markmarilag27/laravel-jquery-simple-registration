import { defineConfig } from "vite";
import laravel from "laravel-vite-plugin";
import inject from "@rollup/plugin-inject";

export default defineConfig({
  plugins: [
    laravel({ input: ["resources/js/app.js"], refresh: true }),
    inject({
      $: "jquery",
      jQuery: "jquery",
    }),
  ],
  optimizeDeps: {
    include: ["jquery"],
  },
  server: {
    host: "0.0.0.0",
    port: 5173,
    strictPort: true,
    hmr: { host: "localhost" },
  },
});
