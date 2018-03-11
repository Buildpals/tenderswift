require 'rails_helper'

RSpec.describe "RequestForTenders", type: :request do
  describe "GET /request_for_tenders" do
    it "works! (now write some real specs)" do
      get request_for_tenders_path
      expect(response).to have_http_status(200)
    end
  end
end
