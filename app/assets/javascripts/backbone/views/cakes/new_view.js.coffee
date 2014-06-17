Cake.Views.Cakes ||= {}

class Cake.Views.Cakes.NewView extends Backbone.View
  template: JST["backbone/templates/cakes/new"]

  events:
    "submit #new-cake": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (cake) =>
        @model = cake
        window.location.hash = "/#{@model.id}/photos/new"

      error: (cake, jqXHR) =>
        #@model.set({errors: $.parseJSON(jqXHR.responseText)})
        error = new Cake.Views.ErrorView
          el: @$('form#new-cake'),
          attributesWithErrors: $.parseJSON(jqXHR.responseText)
        error.render()
    )

  render: ->
    $(@el).html(@template(@model.toJSON()))

    this.$("form").backboneLink(@model)

    return this
