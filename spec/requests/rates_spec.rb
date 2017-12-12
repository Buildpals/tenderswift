require 'rails_helper'

RSpec.describe "Rates", type: :request do
  describe "GET /rates" do
    it "works! (now write some real specs)" do
      get rates_path
      expect(response).to have_http_status(200)
    end
  end
end
