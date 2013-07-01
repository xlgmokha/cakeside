require 'spec_helper'

describe CreationsController do
  let(:user){ FactoryGirl.create(:user) }
  let(:creation){ FactoryGirl.create(:creation, :user => user) }

  before(:each) do
    photo = File.new(File.join(Rails.root, 'spec/fixtures/images/example.png'))
    creation.add_photo(photo)
  end

  describe "GET index" do
    let(:restricted_creation){ FactoryGirl.create(:creation, :user => user, :is_restricted => true) }

    before { get :index }

    it "should display all creations" do
      assigns(:creations).should include(creation)
    end

    it "should not include restricted creations" do
      assigns(:creations).should_not include(restricted_creation)
    end
  end

  context "when logged in" do
    before { http_login(user) }

    describe "GET show" do
      it "assigns the requested creation as @creation" do
        get :show, :id => creation.id
        assigns(:creation).should eq(creation)
      end
    end

    describe "GET new" do
      it "assigns a new creation as @creation" do
        new_creation = fake
        Creation.stub(:new) { new_creation }
        get :new
        assigns(:creation).should be(new_creation)
      end
    end

    describe "GET edit" do
      it "assigns the requested creation as @creation" do
        get :edit, :id => creation.id
        assigns(:creation).should eq(creation)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        before :each do
          creations = fake
          user.stub(:creations).and_return(creations)
          creations.stub(:create).and_return(creation)
          post :create, :creation => {:id => creation.id, :name => 'new name'}
        end

        it "assigns a newly created creation as @creation" do
          assigns(:creation).should eq(creation)
        end

        it "redirects to the created creation" do
          response.should redirect_to(new_creation_photo_path(creation))
        end
      end

      describe "with invalid params" do
        before :each do
          post :create, :creation => {:name => ''}
        end
        it "re-renders the 'new' template" do
          response.should render_template("new")
        end
        it "should include the errors" do
          assigns(:creation).errors.any?.should be_true
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        before :each do
          put :update, :id => creation.id, :creation => {:name => 'params'}
        end
        it "assigns the requested creation as @creation" do
          assigns(:creation).should eq(creation)
        end

        it "redirects to the creation" do
          response.should redirect_to("/creations/#{creation.id}-params/photos/new")
        end
      end

      describe "with invalid params" do
        before :each do
          put :update, :id => creation.id, :creation => {:name=> nil }
        end
        it "assigns the creation as @creation" do
          assigns(:creation).should eq(creation)
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      before :each do
        delete :destroy, :id => creation.id
      end

      it "destroys the requested creation" do
        user.creations.count.should == 0
      end

      it "redirects to the creations list" do
        response.should redirect_to(creations_url)
      end
    end

    describe :mine do
      let!(:my_creation) { FactoryGirl.create(:creation) }
      let!(:other_creation) { FactoryGirl.create(:creation) }

      before :each do
        user.creations << my_creation
        get :mine
      end

      it "should return all of my creations" do
        assigns(:creations).should include(my_creation)
      end

      it "should not return any other creations" do
        assigns(:creations).should_not include(other_creation)
      end
    end
  end

end
