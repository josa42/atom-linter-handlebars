linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"

{Range} = require 'atom'

Handlebars = require 'handlebars'
XRegExp = require('xregexp').XRegExp

path = require 'path'
fs = require 'fs'

class LinterHandlebars extends Linter

  @syntax: ['text.html.handlebars', 'source.hbs', 'source.handlebars']

  linterName: 'handlebars'

  regex: XRegExp(
    'Parse error on line (?<line>[0-9]+)+:\n' +
    '[^\n]*\n' +
    '[^\n]*\n' +
    '(?<message>.*)'
  )

  lintFile: (filePath, callback) ->

    fs.readFile filePath, 'utf8', (err, bufferText) =>
      unless err
        @lint bufferText, callback
      callback([])


  lint: (bufferText, callback) ->

    messages = []

    try
      Handlebars.precompile bufferText, {}

    catch err
      XRegExp.forEach err.message, @regex, (match) =>

        lineIdx = Math.max 0, Number(match.line) - 1

        messages.push
          level: 'error'
          message: match.message
          linter: @linterName
          range: new Range(
            [lineIdx, @startColForRow(lineIdx)],
            [lineIdx, @lineLengthForRow(lineIdx)]
          )

    callback(messages)

  startColForRow: (row) ->
    text = @editor.lineTextForBufferRow row
    if text
      return String(text.match(/^\s*/)).length
    return 0

module.exports = LinterHandlebars
