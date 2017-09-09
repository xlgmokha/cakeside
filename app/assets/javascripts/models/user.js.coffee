#= require ./translation

class CakeSide.Models.User extends Backbone.Model
  modelKey: 'user'
  translation: new CakeSide.Translation('user')
  defaults:
    name: null
    email: null
    password: null

  requiredFields: ['name', 'email', 'password']

  validate: (attributes, options) ->
    errors = {}

    unless new CakeSide.Models.Email(attributes.email).isValid()
      errors['email'] = @translation.errorFor('email', 'invalid')

    _.each @requiredFields, (field) =>
      if _.isEmpty(attributes[field])
        errors[field] = @translation.errorFor(field, 'blank')

    unless attributes.accepted
      errors['accepted'] = @translation.errorFor('accepted', 'accepted')

    return errors if _.keys(errors).length > 0
