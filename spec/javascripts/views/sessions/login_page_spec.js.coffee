describe "CakeSide.Views.LoginForm", ->
  subject = null

  beforeEach ->
    fixture.set '''
<form class="form-horizontal" data-autoview="login-form" id="new_user_session" action="/sessions" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="✓"><input type="hidden" name="authenticity_token" value="NUk9vz3sVMzi09PgQrzOTDcJIki2RgCzHgtpFw0ooSha4lgMt/bUsuAk//Wvi7wb/K6qh+pVrDkKr5a5e66QTw==">
  <div class="form-group">
    <input type="email" name="session[username]" id="session_username" value="" placeholder="Email" class="form-control" required="required">
  </div>
  <div class="form-group">
    <input type="password" name="session[password]" id="session_password" value="" placeholder="Password" class="form-control" required="required">
  </div>
  <p><a href="/passwords/new">Forgot your password?</a></p>
  <input type="submit" name="commit" value="Sign In" class="btn btn-primary">
</form>
    '''

    subject = new CakeSide.Views.LoginForm
      el: $('#new_user_session')

  it "disables the submit button when the email is missing", ->
    subject.field('password').val('password').change()
    expect(subject.$('input[type=submit]').prop('disabled')).toEqual(true)

  it "disables the submit button when the password is missing", ->
    subject.field('username').val('user@email.com').change()
    expect(subject.$('input[type=submit]').prop('disabled')).toEqual(true)

  it "enables the submit button when all required fields are specified", ->
    subject.field('username').val('user@email.com').change()
    subject.field('password').val('password').change()
    expect(subject.$('input[type=submit]').prop('disabled')).toEqual(false)