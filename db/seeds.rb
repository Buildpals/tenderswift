# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or create!d alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create!([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create!(name: 'Luke', movie: movies.first)

quantity_surveyor = QuantitySurveyor.create!(email: 'ohara.invent@gmail.com',
                                            phone_number: '0500011505',
                                            password: 'password',
                                            company_name: 'Buildpals Corportion')

request_for_tender = RequestForTender.create!(project_name: 'East Legon Communication Tower',
                                              deadline: Time.current + 7.days,
                                              country: 'Ghana',
                                              city: 'Accra',
                                              description: 'This RFP is soliciting proposals from qualified contractors, preferably located within the aforementioned region, with demonstrated, relevant experience for all permitting, site development, preparation, erection and installation of small footprint, self supporting, guyed communication towers and related wireless communication equipment. Quotes should include the cost of purchase and installation of the related wireless radio communication equipment. Proposals must include guyed tower with the capability of accommodating the placement of four (4) single vertical antenna (tenant) spaces for communication equipment which includes the placement of four (4) 11’ microwave dishes. The entire project must be built to completion and billed no later than July 31. Successful proposals must acknowledge.',
                                              budget: '200000',
                                              quantity_surveyor: quantity_surveyor)

boq = Boq.create!(name: request_for_tender.project_name,
                  request_for_tender: request_for_tender)

page_one = Page.create!(name: 'Page One', boq: boq)
page_two = Page.create!(name: 'Page Two', boq: boq)

item_one = Item.create!(name: 'A', description: 'First Item', quantity: '42',
                        unit: 'm2', boq: boq, page: page_one)
item_two = Item.create!(name: 'B', description: 'Second Item', quantity: '43',
                        unit: 'l',  boq: boq, page: page_one)
item_three = Item.create!(name: 'C', description: 'Third Item', quantity: '44',
                          unit: 'nr', boq: boq, page: page_one)
item_four = Item.create!(name: 'D', description: 'Fourth Item', quantity: '45',
                         unit: 'm2',  boq: boq, page: page_two)
item_five = Item.create!(name: 'E', description: 'Fifth Item', quantity: '46',
                         unit: 'nr',  boq: boq, page: page_two)

participant = Participant.create!(email: 'bkwaku@rocketmail.com',
                                  phone_number: '0509825831',
                                  first_name: 'Kwaku',
                                  last_name: 'Boateng',
                                  comment: 'My comments here',
                                  interested: true,
                                  interested_declaration_time: Time.current + 8.days,
                                  bid_submission_time: Time.current + 10.days,
                                  request_for_tender: request_for_tender)

filled_item_one = FilledItem.new(amount: '2', rate: '75')
filled_item_one.participant = participant
filled_item_one.item = item_one
filled_item_one.save!

filled_item_two = FilledItem.new(amount: '2', rate: '65')
filled_item_two.participant = participant
filled_item_two.item = item_two
filled_item_two.save!

filled_item_three = FilledItem.new(amount: '2', rate: '65')
filled_item_three.participant = participant
filled_item_three.item = item_three
filled_item_three.save!

filled_item_four = FilledItem.new(amount: '2', rate: '55')
filled_item_four.participant = participant
filled_item_four.item = item_four
filled_item_four.save!

filled_item_five = FilledItem.new(amount: '2', rate: '45')
filled_item_five.participant = participant
filled_item_five.item = item_five
filled_item_five.save!

#####################################################

participant_two = Participant.create!(email: 'kbboateng14@gmail.com',
                                      phone_number: '0509825851',
                                      first_name: 'Kwaku',
                                      last_name: 'Boakye',
                                      comment: 'My comments here',
                                      interested: true,
                                      interested_declaration_time: Time.current + 9.days,
                                      bid_submission_time: Time.current + 11.days,
                                      request_for_tender: request_for_tender)

filled_item_second_one = FilledItem.new(amount: '3', rate: '75')
filled_item_second_one.participant = participant_two
filled_item_second_one.item = item_one
filled_item_second_one.save!

filled_item_second_two = FilledItem.new(amount: '3', rate: '65')
filled_item_second_two.participant = participant_two
filled_item_second_two.item = item_two
filled_item_second_two.save!

filled_item_second_three = FilledItem.new(amount: '3', rate: '65')
filled_item_second_three.participant = participant_two
filled_item_second_three.item = item_three
filled_item_second_three.save!

filled_item_second_four = FilledItem.new(amount: '3', rate: '55')
filled_item_second_four.participant = participant_two
filled_item_second_four.item = item_four
filled_item_second_four.save!

filled_item_second_five = FilledItem.new(amount: '3', rate: '45')
filled_item_second_five.participant = participant_two
filled_item_second_five.item = item_five
filled_item_second_five.save!
