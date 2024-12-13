const path = require('path')

require("esbuild").build({
  entryPoints: ["application.js"],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  watch: process.argv.includes("--watch"),
  sourcemap: true,
  loader: { 
    '.js': 'jsx',
    '.css': 'css'
  }
}).catch(() => process.exit(1))
