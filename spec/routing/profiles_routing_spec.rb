require 'rails_helper'

describe ProfilesController do
  describe "routing" do
    it "routes to index" do
      get('/profiles/').should route_to("profiles#index")
    end

    it "routes to #show" do
      get("/profiles/1").should route_to("profiles#show", :id => "1")
    end
  end
end
