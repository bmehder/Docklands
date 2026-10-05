import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'

const guide = await readFile('dist/guides/collections/index.html', 'utf8')
const homePage = await readFile('dist/index.html', 'utf8')

assert.match(guide, /class="shiki github-dark-default"/)
assert.match(guide, /<span style="color:/)
assert.match(homePage, /<pre><code><b>01<\/b> Markdown parsed/)

console.log('Syntax-highlighting checks passed')
