require "rails_helper"

RSpec.describe ParticipantsController, type: :routing do
  describe "routing" do

    it "routes to #edit" do
      expect(:get => "/participants/1/edit").to route_to("participants#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/participants").to route_to("participants#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/participants/1").to route_to("participants#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/participants/1").to route_to("participants#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/participants/1").to route_to("participants#destroy", :id => "1")
    end

  end
end
