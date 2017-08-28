require 'rails_helper'

RSpec.describe Request, type: :model do
  describe "associations" do
    it "forces request to have a boq" do
      request = Request.new(project_name: "my project", deadline: Date.new, country: "Ghana", city: "Accra", description: "Practise it", budget: "200,000")
      boq = Boq.new(name: "trying one")
      request.boq = boq
      request.save!
      expect(request.boq).not_to be(nil)
    end
  end
end
