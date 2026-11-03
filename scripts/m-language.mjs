// Article-specific grammar for Codename M's current design sketches.
export const mLanguage = {
  name: 'm',
  scopeName: 'source.codename-m',
  patterns: [
    { name: 'comment.line.double-slash.m', match: '//.*$' },
    {
      name: 'string.quoted.double.m',
      begin: '"',
      end: '"',
      patterns: [{ name: 'constant.character.escape.m', match: '\\\\.' }],
    },
    { name: 'keyword.control.m', match: '\\b(import|export|as|type|opaque|alias|fork|match|if)\\b' },
    { name: 'support.type.m', match: '\\b(Number|String|Boolean|Unit|List|Maybe|Result|Effect)\\b' },
    { name: 'constant.numeric.m', match: '\\b[0-9]+(?:\\.[0-9]+)?\\b' },
    { name: 'entity.name.type.m', match: '\\b[A-Z][A-Za-z0-9_]*\\b' },
    { name: 'support.function.m', match: '\\b(identity|add|subtract|divide)\\b' },
    { name: 'variable.other.property.m', match: '\\.[a-z][A-Za-z0-9_]*' },
    { name: 'keyword.operator.m', match: '\\|>|->|==|!=|<=|>=|&&|\\|\\||[=+*/<>:-]' },
  ],
}
