"use babel"

import path from 'path'
import Handlebars from 'handlebars'
import XRegExp from 'xregexp'

module.exports = {

  name: 'handlebars',

  grammarScopes: ['text.html.handlebars', 'source.hbs', 'source.handlebars'],

  scope: 'file',

  lintOnFly: true,

  regex: XRegExp(
    'Parse error on line (?<line>[0-9]+)+:\n' +
    '[^\n]*\n' +
    '[^\n]*\n' +
    '(?<message>.*)'
  ),

  lint(textEditor) {

    return new Promise((resolve, reject) => {

      messages = []
      bufferText = textEditor.getText()

      try {
        Handlebars.precompile(bufferText, {})

      } catch(err) {
        XRegExp.forEach(err.message, this.regex, (match) => {
          messages.push({
            type: 'Error',
            text: match.message,
            filePath: textEditor.getPath(),
            range: this.lineRange(match.line - 1, textEditor)
          })
        })
      }

      resolve(messages)
    })
  },

  lineRange(lineIdx, textEditor) {
    const line = textEditor.getBuffer().lineForRow(lineIdx)
    const pre = String(line.match(/^\s*/))

    return [[lineIdx, pre.length], [lineIdx, line.length]]
  }
}
