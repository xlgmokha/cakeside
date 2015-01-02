require "rails_helper"

describe PublishCakeToTwitter do
  let(:twitter) { double(tweet: '') }
  let(:cakes) { double }

  subject { PublishCakeToTwitter.new(twitter, cakes) }

  describe "#handles?" do
    it "handles cake_published" do
      expect(subject.handles?(:cake_published)).to be_truthy
    end
  end

  describe "#handle" do
    let(:artist) { User.new(name: 'joe') }
    let(:cake) { Creation.new(id: id, name: 'yummy') }
    let(:id) { 88 }

    before :each do
      allow(cake).to receive(:user).and_return(artist)
      allow(cakes).to receive(:find).with(id).and_return(cake)
    end

    context "when the cake is published and safe for kids" do
      before :each do
        allow(cake).to receive(:published?).and_return(true)
      end

      it "tweets new cakes" do
        subject.handle(cake_id: id)
        expect(twitter).to have_received(:tweet).with("yummy By joe on http://www.blah.com/cakes/88-yummy!")
      end
    end

    context "when the cake is not published" do
      before :each do
        allow(cake).to receive(:published?).and_return(false)
      end

      it "should not publish any tweets" do
        subject.handle(cake_id: id)
        expect(twitter).not_to have_received(:tweet)
      end
    end
  end
end
