linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
path = require 'path'

class LinterHandlebars extends Linter

  @syntax: ['text.html.handlebars', 'source.hbs', 'source.handlebars']

  isNodeExecutable: yes

  cmd: 'handlebars'

  errorStream: 'stderr'

  linterName: 'handlebars'

  regex:
      'Error: Parse error on line (?<line>[0-9]+)+:\n' +
      '[^\n]*\n' +
      '[^\n]*\n' +
      '(?<message>.*)\n'

  constructor: (editor)->
    super(editor)
    @executablePath = path.join __dirname, '..', 'node_modules', 'handlebars', 'bin'

module.exports = Linterhandlebars
