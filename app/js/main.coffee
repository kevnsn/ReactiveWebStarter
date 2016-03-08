# Load in dependencies from deps.coffee; which references scripts in index.html
{_, $, rx, rxt, R,  moment} = require './deps.coffee'
{bind} = rx
{MainView} = require './templates/home.coffee'

# Create an API object used to interface with server
api = require './api.coffee'

# Creates a object to store information about the current 'context' of the application
contexts = require './contexts.coffee'

# Included to handle page URLs appropriately
urls = require './urls.coffee'

# Run on page load
$ ->
  # Insert functions to run here
  # Create a new API object(s) to interace with the backend
  postApi = new api.PostApi(new api.RestApi())

  # Create a new context object with API object(s)
  appContext = new contexts.AppContext(postApi)
  window.appContext = appContext
  window.router = urls.initRouting(appContext)

  $("body").append MainView({appContext: appContext})
