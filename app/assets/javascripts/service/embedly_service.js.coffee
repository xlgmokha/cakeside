class CakeSide.EmbedlyService
  retrieve_info_on: (url, callback) ->
    $.embedly.extract(url, {}).progress(callback)
