"use babel"

import { config } from '../lib/init'


export function resetConfig() {
  Object.keys(config || {})
    .forEach((key) => {
      return atom.config.set("linter-handlebars.#{key}", config[key].default)
    })
}
