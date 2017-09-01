# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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
