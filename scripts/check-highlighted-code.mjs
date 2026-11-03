import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'

const guide = await readFile('dist/guides/collections/index.html', 'utf8')
const homePage = await readFile('dist/index.html', 'utf8')

assert.match(guide, /class="shiki github-dark-default"/)
assert.match(guide, /<span style="color:/)
assert.match(homePage, /<pre><code><b>01<\/b> Markdown parsed/)

console.log('Syntax-highlighting checks passed')

const mArticle = await readFile(
  'dist/notes/what-if-the-code-showed-the-shape-of-the-problem/index.html',
  'utf8',
)
assert.equal((mArticle.match(/class="shiki github-dark-default"/g) ?? []).length, 20)
assert.doesNotMatch(mArticle, /<pre><code class="language-(?:m|js)">/)
assert.match(mArticle, /<span style="color:[^"]+">[^<]*\bfork<\/span>/)
assert.match(mArticle, /m-function-application\.svg/)
assert.match(mArticle, /m-fork-tuple\.svg/)
assert.match(mArticle, /NaN/)

console.log('M article highlighting and diagram checks passed')
