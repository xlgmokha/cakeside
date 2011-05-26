require 'spec_helper'

describe "creations/show.html.erb" do
  before(:each) do
    @creation = assign(:creation, stub_model(Creation,
      :name => "Name",
      :story => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end