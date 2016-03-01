GenerateTest = require '../lib/generate-test'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "GenerateTest", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('generate-test')

  describe ".getPathToGenerate", ->
    it "returns correct values for Rails", ->
      g = GenerateTest.getPathToGenerate

      expect(g(null)).toEqual(undefined)
      expect(g("")).toEqual(undefined)
      expect(g("/not/a/match")).toEqual(undefined)
      expect(g('/filesystem/git/project/app/models/user.rb')).toEqual('/filesystem/git/project/test/models/user_test.rb')
