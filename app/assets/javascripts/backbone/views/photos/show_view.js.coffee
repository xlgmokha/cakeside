Cake.Views.Photos ||= {}

class Cake.Views.Photos.ShowView extends Backbone.View
  template: JST["backbone/templates/photos/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
