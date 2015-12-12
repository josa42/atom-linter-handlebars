path = require 'path'
Handlebars = require 'handlebars'
helpers = require 'atom-linter'
XRegExp = require('xregexp').XRegExp

module.exports =

  name: 'handlebars'

  grammarScopes: ['text.html.handlebars', 'source.hbs', 'source.handlebars']

  scope: 'file'

  lintOnFly: true

  regex: XRegExp(
    'Parse error on line (?<line>[0-9]+)+:\n' +
    '[^\n]*\n' +
    '[^\n]*\n' +
    '(?<message>.*)'
  )

  lint: (textEditor) ->

    return new Promise (resolve, reject) =>

      messages = []
      bufferText = textEditor.getText()

      try
        Handlebars.precompile bufferText, {}

      catch err
        XRegExp.forEach err.message, @regex, (match) ->

          messages.push {
            type: 'Error'
            text: match.message
            filePath: textEditor.getPath()
            range: helpers.rangeFromLineNumber(textEditor, match.line - 1)
          }

      resolve(messages)
