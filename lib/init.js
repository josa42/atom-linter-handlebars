"use babel"

import LinterHandlebarsProvider from './linter-handlebars-provider'
import { install } from 'atom-package-deps'

export default {

  activate() {
    if (!atom.inSpecMode()) {
      install('linter-handlebars')
    }
  },

  provideLinter: () => LinterHandlebarsProvider
}
