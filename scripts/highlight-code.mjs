import { readdir, readFile, writeFile } from 'node:fs/promises'
import { join } from 'node:path'
import { codeToHtml } from 'shiki'

const outputDirectory = 'dist'
const codeBlockPattern =
  /<pre><code class="language-([a-zA-Z0-9_+-]+)">([\s\S]*?)<\/code><\/pre>/g

let highlightedBlockCount = 0
const unsupportedLanguages = new Set()

for (const filePath of await findHtmlFiles(outputDirectory)) {
  const html = await readFile(filePath, 'utf8')
  const highlightedHtml = await highlightCodeBlocks(html)

  if (highlightedHtml !== html) {
    await writeFile(filePath, highlightedHtml)
  }
}

console.log(`Highlighted ${highlightedBlockCount} code blocks in ${outputDirectory}/`)

if (unsupportedLanguages.size > 0) {
  console.log(
    `Left unsupported languages unchanged: ${[...unsupportedLanguages].sort().join(', ')}`,
  )
}

async function findHtmlFiles(directory) {
  const entries = await readdir(directory, { withFileTypes: true })
  const files = []

  for (const entry of entries) {
    const entryPath = join(directory, entry.name)

    if (entry.isDirectory()) {
      files.push(...(await findHtmlFiles(entryPath)))
    } else if (entry.isFile() && entry.name.endsWith('.html')) {
      files.push(entryPath)
    }
  }

  return files
}

async function highlightCodeBlocks(html) {
  let highlightedHtml = ''
  let previousMatchEnd = 0

  for (const match of html.matchAll(codeBlockPattern)) {
    const [originalBlock, language, escapedCode] = match
    const matchStart = match.index

    highlightedHtml += html.slice(previousMatchEnd, matchStart)

    try {
      highlightedHtml += await codeToHtml(decodeHtml(escapedCode), {
        lang: language,
        theme: 'github-dark-default',
      })
      highlightedBlockCount += 1
    } catch {
      highlightedHtml += originalBlock
      unsupportedLanguages.add(language)
    }

    previousMatchEnd = matchStart + originalBlock.length
  }

  return highlightedHtml + html.slice(previousMatchEnd)
}

function decodeHtml(value) {
  return value
    .replace(/&#x([0-9a-f]+);/gi, (_, number) =>
      codePointOrOriginal(number, 16, _),
    )
    .replace(/&#([0-9]+);/g, (_, number) =>
      codePointOrOriginal(number, 10, _),
    )
    .replaceAll('&quot;', '"')
    .replaceAll('&#39;', "'")
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&amp;', '&')
}

function codePointOrOriginal(number, radix, original) {
  const codePoint = Number.parseInt(number, radix)

  try {
    return String.fromCodePoint(codePoint)
  } catch {
    return original
  }
}
