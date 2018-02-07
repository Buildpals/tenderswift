require "rails_helper"

RSpec.describe TenderTransactionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/tender_transactions").to route_to("tender_transactions#index")
    end

    it "routes to #new" do
      expect(:get => "/tender_transactions/new").to route_to("tender_transactions#new")
    end

    it "routes to #show" do
      expect(:get => "/tender_transactions/1").to route_to("tender_transactions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/tender_transactions/1/edit").to route_to("tender_transactions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/tender_transactions").to route_to("tender_transactions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tender_transactions/1").to route_to("tender_transactions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/tender_transactions/1").to route_to("tender_transactions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/tender_transactions/1").to route_to("tender_transactions#destroy", :id => "1")
    end

  end
end
