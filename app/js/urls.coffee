{_, $, rx, rxt, R,  moment, hasher, Router} = require './deps.coffee'
{bind} = rx

{AppContext} = require './contexts.coffee'

exports.urlFor = urlFor = (args...) ->
  return encodeURI router.generate.apply router, args

exports.redirect = redirect = (path) -> window.location.replace(path)

exports.ROUTES = ROUTES = {
  ROOT: 'base'
  DEFAULT: 'default'
  INTRODUCTION: 'introduction'
  POSTS:'posts'
  POSTS_LIST: 'posts_list'
  DEMO: 'demo'
}

exports.initRouting = (appContext) ->
  # Creates a router object
  router = new Router.default()

  # Sets mapping between url paths and ROUTES variables
  setupMapping(router)

  # Creates model logic based on ROUTES variables
  handlers = makeHandlers(router, appContext)
  router.getHandler = (name) ->
    handlers[name]

  # Set page titles appropriately
  titleCell = bind -> appContext.titles()
  titleCell.onSet.sub ([oldval, newval]) ->
    title = (x for x in newval ? [] when x).join(" > ")
    document.title = if title then title + " - Reactive Web Starter" else "Reactive Web Starter"

  onStateChange = ->
    # Change page-specific variables (errors, flash messages, etc)
    hash = History.getState().hash
    router.handleURL(hash)

  History.Adapter.bind window, 'statechange', onStateChange

  router.updateURL = (url) -> History.pushState(url, null, url)
  router.replaceURL = (url) -> History.replaceState(url, null, url)

  onStateChange()

  # Catch clicks on links; if it is to a place that the router can route to, then
  # route instead of navigate.
  $(document).on "click", "a", (e) ->
    href = $(e.target).attr("href")
    if href and router.recognizer.recognize(href)?
      # Track page views here
      console.log "Navigating to " + href
      # Allows for default browser behavor if command or ctrl-clicking the link
      if (e.metaKey || e.ctrlKey)
        return true
      else
        # Handles the link with the router
        router.updateURL(href)
        return false
    else
      return true

  return router

setupMapping = (router) ->
  router.map (match) ->
    match('/home').to(ROUTES.ROOT, (match) ->
      match('').to(ROUTES.INTRODUCTION)
      match('/posts').to(ROUTES.POSTS, (match) ->
        match('').to(ROUTES.POSTS_LIST)
      match('/demo').to(ROUTES.DEMO)
      )
    )


makeHandlers = (router, appContext) ->
  handlers = {}

  # Note, you should be sure to define all your routes in setupMapping
  handlers[ROUTES.ROOT] = {
    events:
      error: (error, transition) ->
        # Catch and throw errors that router.js is catching and burying, so we can get a
        # proper stack trace in the console.
        _.defer -> throw error
    model: ->
  }

  handlers[ROUTES.INTRODUCTION] = {
    model: ->
      console.log "ROUTE: Loaded introduction"
      appContext.mode.set(AppContext.INTRODUCTION)
  }

  handlers[ROUTES.POSTS] = {
    model: ->
      console.log "ROUTE: Loaded posts"
  }

  handlers[ROUTES.DEMO] = {
    model: ->
      console.log "ROUTE: Loaded demo"
      appContext.mode.set(AppContext.DEMO)
  }

  handlers[ROUTES.POSTS_LIST] = {
    model: ->
      console.log "ROUTE: Loaded posts list"
      appContext.mode.set(AppContext.POSTS_LIST)
  }

  return handlers
