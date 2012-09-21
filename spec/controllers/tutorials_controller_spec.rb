require 'spec_helper'

describe TutorialsController do

  def valid_attributes
    {:heading => "hello world"}
  end

  def valid_session
    {}
  end

  let(:user){ FactoryGirl.create(:user) }

  before (:each) do
    request.env['warden'] = mock(Warden, :authenticate => user, :authenticate! => user)
  end

  describe "GET index" do
    it "assigns all tutorials as @tutorials" do
      tutorial = user.tutorials.create! valid_attributes
      get :index, {}, valid_session
      assigns(:tutorials).should eq([tutorial])
    end
  end

  describe "GET show" do
    it "assigns the requested tutorial as @tutorial" do
      tutorial = user.tutorials.create! valid_attributes
      get :show, {:id => tutorial.to_param}, valid_session
      assigns(:tutorial).should eq(tutorial)
    end
  end

  describe "GET new" do
    it "assigns a new tutorial as @tutorial" do
      get :new, {}, valid_session
      assigns(:tutorial).should be_a_new(Tutorial)
    end
  end

  describe "GET edit" do
    it "assigns the requested tutorial as @tutorial" do
      tutorial = user.tutorials.create! valid_attributes
      get :edit, {:id => tutorial.to_param}, valid_session
      assigns(:tutorial).should eq(tutorial)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Tutorial" do
        expect {
          post :create, {:tutorial => valid_attributes}, valid_session
        }.to change(Tutorial, :count).by(1)
      end

      it "assigns a newly created tutorial as @tutorial" do
        post :create, {:tutorial => valid_attributes}, valid_session
        assigns(:tutorial).should be_a(Tutorial)
        assigns(:tutorial).should be_persisted
      end

      it "redirects to the created tutorial" do
        post :create, {:tutorial => valid_attributes}, valid_session
        response.should redirect_to(tutorials_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tutorial as @tutorial" do
        # Trigger the behavior that occurs when invalid params are submitted
        Tutorial.any_instance.stub(:save).and_return(false)
        post :create, {:tutorial => {}}, valid_session
        assigns(:tutorial).should be_a_new(Tutorial)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Tutorial.any_instance.stub(:save).and_return(false)
        post :create, {:tutorial => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested tutorial" do
        tutorial = user.tutorials.create! valid_attributes
        # Assuming there are no other tutorials in the database, this
        # specifies that the Tutorial created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Tutorial.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => tutorial.to_param, :tutorial => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested tutorial as @tutorial" do
        tutorial = user.tutorials.create! valid_attributes
        put :update, {:id => tutorial.to_param, :tutorial => valid_attributes}, valid_session
        assigns(:tutorial).should eq(tutorial)
      end

      it "redirects to the tutorial" do
        tutorial = user.tutorials.create! valid_attributes
        put :update, {:id => tutorial.to_param, :tutorial => valid_attributes}, valid_session
        response.should redirect_to(tutorial)
      end
    end

    describe "with invalid params" do
      it "assigns the tutorial as @tutorial" do
        tutorial = user.tutorials.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Tutorial.any_instance.stub(:save).and_return(false)
        put :update, {:id => tutorial.to_param, :tutorial => {}}, valid_session
        assigns(:tutorial).should eq(tutorial)
      end

      it "re-renders the 'edit' template" do
        tutorial = user.tutorials.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Tutorial.any_instance.stub(:save).and_return(false)
        put :update, {:id => tutorial.to_param, :tutorial => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested tutorial" do
      tutorial = user.tutorials.create! valid_attributes
      expect {
        delete :destroy, {:id => tutorial.to_param}, valid_session
      }.to change(Tutorial, :count).by(-1)
    end

    it "redirects to the tutorials list" do
      tutorial = user.tutorials.create! valid_attributes
      delete :destroy, {:id => tutorial.to_param}, valid_session
      response.should redirect_to(tutorials_url)
    end
  end

end
