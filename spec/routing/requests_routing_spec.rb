require "rails_helper"

RSpec.describe RequestForTendersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/request_for_tenders").to route_to("request_for_tenders#index")
    end

    it "routes to #new" do
      expect(:get => "/request_for_tenders/new").to route_to("request_for_tenders#new")
    end

    it "routes to #show" do
      expect(:get => "/request_for_tenders/1").to route_to("request_for_tenders#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/request_for_tenders/1/edit").to route_to("request_for_tenders#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/request_for_tenders").to route_to("request_for_tenders#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/request_for_tenders/1").to route_to("request_for_tenders#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/request_for_tenders/1").to route_to("request_for_tenders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/request_for_tenders/1").to route_to("request_for_tenders#destroy", :id => "1")
    end

  end
end
