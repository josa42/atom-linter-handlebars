path = require 'path'
Handlebars = require 'handlebars'
XRegExp = require('xregexp').XRegExp

class LinterHandlebars

  scope: 'file'

  scopes: ['text.html.handlebars', 'source.hbs', 'source.handlebars']

  lintOnFly: true

  regex: XRegExp(
    'Parse error on line (?<line>[0-9]+)+:\n' +
    '[^\n]*\n' +
    '[^\n]*\n' +
    '(?<message>.*)'
  )

  @provideLinter: -> new LinterHandlebars()

  @activate: ->
    console.log "activate linter-handlebars" if atom.inDevMode()

    if not atom.packages.getLoadedPackage 'linter'
      atom.notifications.addError """
        [linter-handlebars] `linter` package not found, please install it.
      """

  lint: (textEditor, textBuffer) ->

    return new Promise (resolve, reject) =>

      messages = []
      bufferText = textBuffer.cachedText

      try
        Handlebars.precompile bufferText, {}

      catch err
        XRegExp.forEach err.message, @regex, (match) =>

          range = @lineRange match.line, bufferText

          messages.push {
            type: 'Error'
            message: match.message
            file: textEditor.getPath()
            position: [
              [match.line, range[0]],
              [match.line, range[1]]
            ]
          }

      resolve(messages)

  lineRange: (lineNo, bufferText) ->

    line = bufferText.split(/\n/)[lineNo - 1] or ''
    pre = String line.match /^\s*/

    return [pre.length, line.length]

module.exports = LinterHandlebars
