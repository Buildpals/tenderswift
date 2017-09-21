require 'rails_helper'

RSpec.describe "AnswerBoxes", type: :request do
  describe "GET /answer_boxes" do
    it "works! (now write some real specs)" do
      get answer_boxes_path
      expect(response).to have_http_status(200)
    end
  end
end
