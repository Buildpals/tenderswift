require 'rails_helper'

RSpec.describe Contractors::AfterSignupController, type: :controller do

  describe "GET #company_name" do
    it "returns http success" do
      get :company_name
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #password" do
    it "returns http success" do
      get :password
      expect(response).to have_http_status(:success)
    end
  end

end
