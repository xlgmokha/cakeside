CakeSide.Views.Profiles ||= {}

class CakeSide.Views.Profiles.ShowView extends Marionette.ItemView
  template: JST["backbone/templates/profiles/show"]
  ui:
    name: '#user_name'
    email: '#user_email'
    city: '#user_city'
    website: '#user_website'
    facebook: '#user_facebook'
    twitter: '#user_twitter'
    save_button: '#save-button'
    cancel_button: '#cancel-button'
    status: '#status-message'

  modelEvents:
    'invalid': 'displayError'
    'sync': 'syncedUp'

  events:
    "submit #profile-form": "save"
    "keyup input": "refreshStatus"
    'click #cancel-button': 'cancel'

  save: (event) ->
    event.preventDefault()
    event.stopPropagation()
    @disableSaveButton()
    @model.save(null,
      success: @savedSuccessfully
      error: @couldNotSave
    )

  syncedUp: (event) ->
    console.log(arguments)
    console.log('syncd')

  savedSuccessfully: (profile) =>
    @disableSaveButton()
    @ui.status.removeClass('hidden')
    @ui.status.removeClass('alert-error')
    @ui.status.html("Saved!")

  couldNotSave: =>
    console.log('fudge')

  enableSaveButton: ->
    @ui.save_button.removeAttr('disabled')

  disableSaveButton: ->
    @ui.save_button.attr('disabled', 'disabled')

  displayError: ->
    @disableSaveButton()
    @ui.status.addClass('alert-error')
    @ui.status.removeClass('hidden')
    @ui.status.html(@model.validationError)

  refreshStatus: ->
    @ui.status.addClass('hidden')
    @enableSaveButton()
    @model.set('name', @ui.name.val())
    @model.set('email', @ui.email.val())
    @model.set('city', @ui.city.val())
    @model.set('website', @ui.website.val())
    @model.set('facebook', @ui.facebook.val())
    @model.set('twitter', @ui.twitter.val())
    @model.isValid()

  cancel: ->
    @enableSaveButton()
