require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe LikesController do

  # This should return the minimal set of attributes required to create a valid
  # Like. As you add validations to Like, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all likes as @likes" do
      like = Like.create! valid_attributes
      get :index, :creation_id => "1"
      assigns(:likes).should eq([like])
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Like" do
        expect {
          post :create, :like => valid_attributes
        }.to change(Like, :count).by(1)
      end

      it "assigns a newly created like as @like" do
        post :create, :like => valid_attributes
        assigns(:like).should be_a(Like)
        assigns(:like).should be_persisted
      end

      it "redirects to the created like" do
        post :create, :like => valid_attributes
        response.should redirect_to(Like.last)
      end
    end
  end
end
