import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],

  server: {
    host: true, // This makes the server accessible externally
    port: 3000, // You can specify a port, or let Vite pick one
  },
})
