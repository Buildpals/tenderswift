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


  describe "Reading Excel" do
    it "forces number of excel sheets to equal the number of pages in boq" do
      #pending "add forces number of excel sheets to equal the number of pages in boq #{__FILE__}"
      #file = Creek::Book.new excel.document, remote: true
      #no_of_worksheets = file.sheets.lenght
      #boq = Request.read_excel()
    end
  end


end
