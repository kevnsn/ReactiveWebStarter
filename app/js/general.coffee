{_, $, rx, rxt, R,  moment} = require './deps.coffee'
{bind} = rx

exports.promiseBind = promiseBind = ({init, maker, processor, onFail}) ->
  init ?= null
  onFail ?= ->
  processor = processor ? _.identity
  loadingCell = rx.cell(false)
  cell = rx.asyncBind init, ->
    @.record =>
      promise = maker()
      if promise?
        loadingCell.set(true)
        promise.done (res) =>
          rx.transaction =>
            loadingCell.set(false)
            @.done(processor(res))
        promise.fail (res) =>
          rx.transaction =>
            loadingCell.set(false)
            onFail(@.done, res)
      else @.done(init)
  cell.loading = bind -> loadingCell.get()
  return cell
