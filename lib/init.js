"use babel"

import LinterHandlebarsProvider from './linter-handlebars-provider'
import packageDeps from 'atom-package-deps'

export default {

  activate() {
    if (!atom.inSpecMode()) {
      packageDeps.install('linter-handlebars')
    }
  },

  provideLinter: () => LinterHandlebarsProvider
}
