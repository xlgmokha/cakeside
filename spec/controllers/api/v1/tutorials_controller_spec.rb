require "rails_helper"

describe Api::V1::TutorialsController do
  let(:user) { create(:user) }

  before :each do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.authentication_token)
  end

  describe "#index" do
    let(:my_tutorial)  { create(:tutorial, user: user) }
    let(:other_tutorial)  { create(:tutorial) }


    it "returns the users tutorials" do
      get :index, format: :json
      expect(assigns(:tutorials)).to include(my_tutorial)
      expect(assigns(:tutorials)).to_not include(other_tutorial)
    end
  end

  describe "#create" do
    it "creates a new tutorial" do
      attributes = {
        url: "https://twitter.com/",
        image_url: "https://abs.twimg.com/a/1405611403/img/t1/front_page/exp_wc2014_gen_laurenlemon.jpg",
        heading: "Twitter",
        description: "Connect with your friends - and other fascinating people. Get in-the-moment updates on the things that interest you. And watch events unfold, in real time, from every angle.",
        tags: "cake,cookie",
      }
      post :create, tutorial: attributes, format: :json

      expect(assigns(:tutorial)).to be_present
      expect(assigns(:tutorial).url).to eql(attributes[:url])
      expect(assigns(:tutorial).description).to eql(attributes[:description])
      expect(assigns(:tutorial).heading).to eql(attributes[:heading])
      expect(assigns(:tutorial).tags.count).to eql(2)
      expect(assigns(:tutorial).tags.first.name).to eql('cake')
      expect(assigns(:tutorial).tags.last.name).to eql('cookie')
    end
  end
end