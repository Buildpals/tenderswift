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
item_one = Item.new(name: "A", description: "First Item", quantity: "424", unit: "m2", rate: "4353")
item_two = Item.new(name: "B", description: "First Item", quantity: "424", unit: "m2", rate: "4353")
item_three = Item.new(name: "C", description: "First Item", quantity: "424", unit: "m2", rate: "4353")
item_four = Item.new(name: "D", description: "First Item", quantity: "424", unit: "m2", rate: "4353")
item_five = Item.new(name: "E", description: "First Item", quantity: "424", unit: "m2", rate: "4353")
section_one.items << item_one; section_one.items << item_two; section_one.items << item_three; section_two.items << item_four; section_two.items << item_five
request.boq = boq
page_one.boq = boq; page_two.boq = boq
boq.save!; page_one.save!; page_two.save!; section_one.save!; section_two.save!; section_three.save!

participant = Participant.create(email: "bkwaku@rocketmail.com", phone_number: "0509825831", first_name: "Kwaku", last_name: "Boateng", comment: "My comments here", interested: true, interested_declaration_time: Date.new, bid_submission_time: Date.new, request_for_tender_id: 1)
filled_item_one = FilledItem.new(amount: "2", rate: "75")
filled_item_one.participant = participant
filled_item_one.item = item_one
filled_item_one.save!

filled_item_two = FilledItem.new(amount: "2", rate: "65")
filled_item_two.participant = participant
filled_item_two.item = item_two
filled_item_two.save!

filled_item_three = FilledItem.new(amount: "2", rate: "65")
filled_item_three.participant = participant
filled_item_three.item = item_three
filled_item_three.save!

filled_item_four = FilledItem.new(amount: "2", rate: "55")
filled_item_four.participant = participant
filled_item_four.item = item_four
filled_item_four.save!

filled_item_five = FilledItem.new(amount: "2", rate: "45")
filled_item_five.participant = participant
filled_item_five.item = item_five
filled_item_five.save!


#####################################################

participant_two = Participant.create(email: "kbboateng14@gmail.com", phone_number: "0509825851", first_name: "Kwaku", last_name: "Boakye", comment: "My comments here", interested: true, interested_declaration_time: Date.new, bid_submission_time: Date.new, request_for_tender_id: 1)
filled_item_second_one = FilledItem.new(amount: "3", rate: "75")
filled_item_second_one.participant = participant_two
filled_item_second_one.item = item_one
filled_item_second_one.save!

filled_item_second_two = FilledItem.new(amount: "3", rate: "65")
filled_item_second_two.participant = participant_two
filled_item_second_two.item = item_two
filled_item_second_two.save!

filled_item_second_three = FilledItem.new(amount: "3", rate: "65")
filled_item_second_three.participant = participant_two
filled_item_second_three.item = item_three
filled_item_second_three.save!

filled_item_second_four = FilledItem.new(amount: "3", rate: "55")
filled_item_second_four.participant = participant_two
filled_item_second_four.item = item_four
filled_item_second_four.save!

filled_item_second_five = FilledItem.new(amount: "3", rate: "45")
filled_item_second_five.participant = participant_two
filled_item_second_five.item = item_five
filled_item_second_five.save!