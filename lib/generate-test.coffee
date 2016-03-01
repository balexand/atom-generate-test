fs = require 'fs'
GenerateTestView = require './generate-test-view'
{CompositeDisposable} = require 'atom'

module.exports = GenerateTest =
  generateTestView: null
  modalPanel: null
  subscriptions: null

  getPathToGenerate: (path) ->
    return unless path

    match = /^(.*)\/app\/(.+)\.rb$/.exec(path)

    if match && match.length >= 3
      "#{match[1]}/test/#{match[2]}_test.rb"

  activate: (state) ->
    @generateTestView = new GenerateTestView(state.generateTestViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @generateTestView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'generate-test:generate': => @generate()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @generateTestView.destroy()

  serialize: ->
    generateTestViewState: @generateTestView.serialize()

  generate: ->
    editor = atom.workspace.getActiveTextEditor()
    path = editor?.getPath?()

    p = @getPathToGenerate(path)
    if p
      console.log p
      fs.appendFileSync(p, "")
      atom.workspace.open(p)
