{_, $, rx, rxt} = require './deps.coffee'
{bind} = rx
general = require './general.coffee'
exports.AppContext = class AppContext
  @POSTS_LIST = "posts"
  @INTRODUCTION = "introduction"
  @DEMO = "demo"

  constructor: (@postApi) ->
    # Create a reactive cell for determining which page the user is on
    @mode = rx.cell(undefined)
    # Create child contexts here
    @postListContext = new PostListContext @postApi
    @demoContext = new DemoContext

  curViewContext: ->
    switch @mode.get()
      when AppContext.POST_LIST then @postListContext
      when AppContext.POST then @postContext
  titles: -> @curViewContext()?.titles()

class PostListContext
  constructor: (@postApi) ->
  titles: -> ["Posts"]

class DemoContext
  constructor: () ->
  titles: -> ["Reactive Demo"]
