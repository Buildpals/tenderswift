require 'rails_helper'

RSpec.describe "Boqs", type: :request do
  describe "GET /boqs" do
    it "works! (now write some real specs)" do
      get boqs_path
      expect(response).to have_http_status(200)
    end
  end
end
