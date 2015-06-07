LinterBase = require "./linter-base"
path = require 'path'

class LinterHandlebars extends LinterBase

  scopes: ['text.html.handlebars', 'source.hbs', 'source.handlebars']

  lintOnFly: false

  isNodeExecutable: yes

  cmd: 'handlebars'

  errorStream: 'stderr'

  linterName: 'handlebars'

  regex:
      'Error: Parse error on line (?<line>[0-9]+)+:\n' +
      '[^\n]*\n' +
      '[^\n]*\n' +
      '(?<message>.*)\n'

  constructor: () ->
    @executablePath = path.join __dirname, '..', 'node_modules', '.bin'
    super()

module.exports = LinterHandlebars
