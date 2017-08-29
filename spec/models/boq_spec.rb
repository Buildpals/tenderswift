require 'rails_helper'

RSpec.describe Boq, type: :model do
  describe "class methods" do

    it "makes us get the total contract sum of a bill of quantity" do
      request = RequestForTender.new(project_name: "my project", deadline: Date.new, country: "Ghana", city: "Accra", description: "Practise it", budget: "200,000")
      boq = Boq.new(name: "trying one")
      page_one = Page.new(name: "new page One"); page_two = Page.new(name: "new page Two")
      section_one = Section.new(name: "new section One"); section_two = Section.new(name: "new section Two"); section_three = Section.new(name: "new section Three")
      page_one.sections << section_one; page_two.sections << section_two; page_one.sections << section_three
      item_one = Item.new(name: "A", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_two = Item.new(name: "B", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_three = Item.new(name: "C", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_four = Item.new(name: "D", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_five = Item.new(name: "E", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      section_one.items << item_one; section_one.items << item_two; section_one.items << item_three; section_two.items << item_four; section_two.items << item_five
      request.boq = boq
      page_one.boq = boq; page_two.boq = boq
      boq.save!; page_one.save!; page_two.save!; section_one.save!; section_two.save!; section_three.save!
      expect(boq.get_total_cost).to eql(25.0)
    end


    it "gets the total amount of a section" do
      request = RequestForTender.new(project_name: "my project", deadline: Date.new, country: "Ghana", city: "Accra", description: "Practise it", budget: "200,000")
      boq = Boq.new(name: "trying one")
      page_one = Page.new(name: "new page One"); page_two = Page.new(name: "new page Two")
      section_one = Section.new(name: "new section One"); section_two = Section.new(name: "new section Two"); section_three = Section.new(name: "new section Three")
      page_one.sections << section_one; page_two.sections << section_two; page_one.sections << section_three
      item_one = Item.new(name: "A", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_two = Item.new(name: "B", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_three = Item.new(name: "C", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_four = Item.new(name: "D", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_five = Item.new(name: "E", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      section_one.items << item_one; section_one.items << item_two; section_one.items << item_three; section_two.items << item_four; section_two.items << item_five
      request.boq = boq
      page_one.boq = boq; page_two.boq = boq
      boq.save!; page_one.save!; page_two.save!; section_one.save!; section_two.save!; section_three.save!
      expect(Boq.get_section_total_cost(section_one)).to eql(15.0)
    end


    it "gets the breakdown of the boq" do
      request = RequestForTender.new(project_name: "my project", deadline: Date.new, country: "Ghana", city: "Accra", description: "Practise it", budget: "200,000")
      boq = Boq.new(name: "trying one")
      page_one = Page.new(name: "new page One"); page_two = Page.new(name: "new page Two")
      section_one = Section.new(name: "new section One"); section_two = Section.new(name: "new section Two"); section_three = Section.new(name: "new section Three")
      page_one.sections << section_one; page_two.sections << section_two; page_one.sections << section_three
      item_one = Item.new(name: "A", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_two = Item.new(name: "B", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_three = Item.new(name: "C", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_four = Item.new(name: "D", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      item_five = Item.new(name: "E", description: "First Item", quantity: "424", unit: "m2", rate: "4353", amount:5)
      section_one.items << item_one; section_one.items << item_two; section_one.items << item_three; section_two.items << item_four; section_two.items << item_five
      request.boq = boq
      page_one.boq = boq; page_two.boq = boq
      boq.save!; page_one.save!; page_two.save!; section_one.save!; section_two.save!; section_three.save!
      expect(boq.get_break_down).to eql(15.0)
    end

  end
end
