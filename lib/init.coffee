LinterHandlebarsProvider = require './linter-handlebars-provider'
packageDeps = require 'atom-package-deps'

module.exports =

  activate: ->
    console.log "activate linter-handlebars" if atom.inDevMode()

    packageDeps.install 'linter-handlebars'

  provideLinter: -> LinterHandlebarsProvider
