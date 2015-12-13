"use babel"

import path from 'path'
import { resetConfig } from './test-helper'
import LinterHandlebarsProvider from '../lib/linter-handlebars-provider'

describe("Lint handlebars", () => {

  beforeEach(() => {
    resetConfig()
    atom.workspace.destroyActivePaneItem()
    return waitsForPromise(() => {
      return atom.packages.activatePackage('linter-handlebars')
    })
  })

  describe("checks a file with a missing open block", () => {
    it('retuns one error', () => {
      waitsForPromise(() => {
        return atom.workspace.open(path.join(__dirname, 'files', 'error-missing-open.hbs'))
          .then((editor) => LinterHandlebarsProvider.lint(editor))
          .then((messages) => {
            expect(messages.length).toEqual(1)
            expect(messages[0].text).toEqual("Expecting 'EOF', got 'OPEN_ENDBLOCK'")
            expect(messages[0].range).toEqual([[2, 0], [2, 7]])
          })
      })
    })

    it('retuns one error (CRFL)', () => {
      waitsForPromise(() => {
        return atom.workspace.open(path.join(__dirname, 'files', 'error-missing-open-crfl.hbs'))
          .then((editor) => LinterHandlebarsProvider.lint(editor))
          .then((messages) => {
            expect(messages.length).toEqual(1)
            expect(messages[0].text).toEqual("Expecting 'EOF', got 'OPEN_ENDBLOCK'")
            expect(messages[0].range).toEqual([[2, 0], [2, 7]])
          })
      })
    })
  })
})
