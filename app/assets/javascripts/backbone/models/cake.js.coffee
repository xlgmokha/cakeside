class Cake.Models.Cake extends Backbone.Model
  paramRoot: 'cake'

  defaults:
    name: null
    watermark: null
    story: null


class Cake.Collections.CakesCollection extends Backbone.Collection
  model: Cake.Models.Cake
  url: '/api/v1/cakes'
