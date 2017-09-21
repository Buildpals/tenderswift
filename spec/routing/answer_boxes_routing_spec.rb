require "rails_helper"

RSpec.describe AnswerBoxesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/answer_boxes").to route_to("answer_boxes#index")
    end

    it "routes to #new" do
      expect(:get => "/answer_boxes/new").to route_to("answer_boxes#new")
    end

    it "routes to #show" do
      expect(:get => "/answer_boxes/1").to route_to("answer_boxes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/answer_boxes/1/edit").to route_to("answer_boxes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/answer_boxes").to route_to("answer_boxes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/answer_boxes/1").to route_to("answer_boxes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/answer_boxes/1").to route_to("answer_boxes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/answer_boxes/1").to route_to("answer_boxes#destroy", :id => "1")
    end

  end
end
