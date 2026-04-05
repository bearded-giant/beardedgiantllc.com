import { defineConfig } from 'vite'
import { resolve } from 'path'

const root = resolve(__dirname)

export default defineConfig({
  root,
  publicDir: resolve(root, 'public'),
  build: {
    outDir: resolve(root, 'dist'),
    emptyOutDir: true,
  },
})
