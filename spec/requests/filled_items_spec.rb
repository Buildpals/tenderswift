require 'rails_helper'

RSpec.describe "FilledItems", type: :request do
  describe "GET /filled_items" do
    it "works! (now write some real specs)" do
      get filled_items_path
      expect(response).to have_http_status(200)
    end
  end
end
