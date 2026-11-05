import assert from "node:assert/strict"
import { access, readFile } from "node:fs/promises"

const referenceDirectory = "dist/reference"

await Promise.all([
  access(`${referenceDirectory}/index.html`),
  access(`${referenceDirectory}/config.html`),
  access(`${referenceDirectory}/content.html`),
  access(`${referenceDirectory}/collections.html`),
  access(`${referenceDirectory}/generator.html`),
  access(`${referenceDirectory}/shortcodes.html`),
  access(`${referenceDirectory}/assets/static/docklands-mark.svg`),
])

const index = await readFile(`${referenceDirectory}/index.html`, "utf8")
const configuration = await readFile(
  `${referenceDirectory}/config.html`,
  "utf8",
)

assert.doesNotMatch(index, /href="(?:layout|output|docklands)\.html"/)
assert.doesNotMatch(configuration, /github_url|back_to_top|base_url/)
assert.match(configuration, /Collection/)

console.log("Gleam reference documentation checks passed")
