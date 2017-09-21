require "rails_helper"

RSpec.describe BroadcastMessagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/broadcast_messages").to route_to("broadcast_messages#index")
    end

    it "routes to #new" do
      expect(:get => "/broadcast_messages/new").to route_to("broadcast_messages#new")
    end

    it "routes to #show" do
      expect(:get => "/broadcast_messages/1").to route_to("broadcast_messages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/broadcast_messages/1/edit").to route_to("broadcast_messages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/broadcast_messages").to route_to("broadcast_messages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/broadcast_messages/1").to route_to("broadcast_messages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/broadcast_messages/1").to route_to("broadcast_messages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/broadcast_messages/1").to route_to("broadcast_messages#destroy", :id => "1")
    end

  end
end
