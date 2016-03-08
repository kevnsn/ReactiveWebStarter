{$, _} = require './deps.coffee'

exports.ajax = ajax = (method, path, data, opts) ->
  $.ajax(
    _(
      url: "/api/#{_.ltrim(path, '/')}"
      type: method
      mimeType: 'application/json'
      contentType: "application/json; charset=utf-8"
    ).extend(opts)
  ).fail (xhr, txt, err) =>
    console.error "#{method} #{path} with data #{JSON.stringify(data)} failed: #{txt}\n#{err}"
    # Handle Rest API Errors here

exports.RestApi = class RestApi
  get: (path, data) -> ajax 'get', path, data
  post: (path, data) -> ajax 'post', path, data
  put: (path, data) -> ajax 'put', path, data
  delete: (path, data) -> ajax 'delete', path, data

# Creates classes which take a RestApi object as part of the constructor
exports.PostApi = class PostApi
  constructor: (@_api) ->
  getPosts: -> @_api.get('/posts')
  getPost: (postId) ->
    @_api.get("/post/#{encodeURIComponent(postId)}")
