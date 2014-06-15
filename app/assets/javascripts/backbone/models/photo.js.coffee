class Cake.Models.Photo extends Backbone.Model
  paramRoot: 'photo'

  defaults:
    thumb_url: null
    large_url: null

class Cake.Collections.PhotosCollection extends Backbone.Collection
  model: Cake.Models.Photo
  url: '/api/v1/cakes/1/photos'

  initialize: (options) ->
    console.log(options)
