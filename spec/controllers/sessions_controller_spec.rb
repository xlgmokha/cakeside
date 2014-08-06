require "rails_helper"

describe SessionsController do
  describe "#new" do
    it "loads the login page" do
      get :new
      expect(response).to be_success
      expect(assigns(:session)).to be_new_record
    end
  end

  describe "#create" do
    context "when the username and password is correct" do
      let(:user_session) { build(:session, id: SecureRandom.uuid) }
      let(:username) { "joe" }
      let(:password) { "password" }

      it "returns a valid session" do
        Session.stub(:login).with(username, password).and_return(user_session)

        post :create, session: { username: username, password: password }
        expect(cookies.signed[:cookie_monster]).to_not be_nil
        expect(cookies.signed[:cookie_monster]).to eql(user_session.id)
      end
    end
  end
end
