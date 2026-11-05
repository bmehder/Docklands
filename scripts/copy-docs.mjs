import { cp, copyFile, mkdir, rm } from "node:fs/promises"

const source = "build/dev/docs/docklands"
const destination = "dist/reference"

await rm(destination, { recursive: true, force: true })
await mkdir(destination, { recursive: true })
await cp(source, destination, { recursive: true })
await mkdir(`${destination}/assets/static`, { recursive: true })
await copyFile(
  "assets/static/docklands-mark.svg",
  `${destination}/assets/static/docklands-mark.svg`,
)

console.log("Gleam reference documentation → dist/reference/")
