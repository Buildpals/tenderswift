require "rails_helper"

RSpec.describe QuantitySurveyorRatesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/quantity_surveyor_rates").to route_to("quantity_surveyor_rates#index")
    end

    it "routes to #new" do
      expect(:get => "/quantity_surveyor_rates/new").to route_to("quantity_surveyor_rates#new")
    end

    it "routes to #show" do
      expect(:get => "/quantity_surveyor_rates/1").to route_to("quantity_surveyor_rates#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/quantity_surveyor_rates/1/edit").to route_to("quantity_surveyor_rates#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/quantity_surveyor_rates").to route_to("quantity_surveyor_rates#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/quantity_surveyor_rates/1").to route_to("quantity_surveyor_rates#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/quantity_surveyor_rates/1").to route_to("quantity_surveyor_rates#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/quantity_surveyor_rates/1").to route_to("quantity_surveyor_rates#destroy", :id => "1")
    end

  end
end
