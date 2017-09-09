#= require ./translation

class CakeSide.Models.Session extends Backbone.Model
  modelKey: 'session'
  translation: new CakeSide.Translation('session')
  defaults:
    email: null
    password: null

  requiredFields: ['email', 'password']

  validate: (attributes, options) ->
    errors = {}

    unless new CakeSide.Models.Email(attributes.email).isValid()
      errors['email'] = @translation.errorFor('email', 'invalid')

    _.each @requiredFields, (field) =>
      if _.isEmpty(attributes[field])
        errors[field] = @translation.errorFor(field, 'blank')

    return errors if _.keys(errors).length > 0
