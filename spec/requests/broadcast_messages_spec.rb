require 'rails_helper'

RSpec.describe "BroadcastMessages", type: :request do
  describe "GET /broadcast_messages" do
    it "works! (now write some real specs)" do
      get broadcast_messages_path
      expect(response).to have_http_status(200)
    end
  end
end
