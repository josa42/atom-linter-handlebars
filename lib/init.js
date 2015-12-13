"use babel"

import LinterHandlebarsProvider from './linter-handlebars-provider'
const packageDeps = require('atom-package-deps')

export default {

  activate() {
    packageDeps.install()
  },

  provideLinter: () => LinterHandlebarsProvider
}
