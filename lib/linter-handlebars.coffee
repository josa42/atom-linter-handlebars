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

      try
        Handlebars.precompile(textBuffer.cachedText, {})

      catch err
        XRegExp.forEach err.message, @regex, (match) =>
          messages.push {
            type: 'Error'
            message: match.message
            file: textEditor.getPath()
            position: [[match.line, 0], [match.line, 0]]
          }

      resolve(messages)

module.exports = LinterHandlebars
