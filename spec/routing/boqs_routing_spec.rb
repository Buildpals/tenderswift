require "rails_helper"

RSpec.describe BoqsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/boqs").to route_to("boqs#index")
    end

    it "routes to #new" do
      expect(:get => "/boqs/new").to route_to("boqs#new")
    end

    it "routes to #show" do
      expect(:get => "/boqs/1").to route_to("boqs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/boqs/1/edit").to route_to("boqs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/boqs").to route_to("boqs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/boqs/1").to route_to("boqs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/boqs/1").to route_to("boqs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/boqs/1").to route_to("boqs#destroy", :id => "1")
    end

  end
end
