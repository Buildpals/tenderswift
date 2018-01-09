require 'rails_helper'

RSpec.describe "QuantitySurveyorRates", type: :request do
  describe "GET /quantity_surveyor_rates" do
    it "works! (now write some real specs)" do
      get quantity_surveyor_rates_path
      expect(response).to have_http_status(200)
    end
  end
end
