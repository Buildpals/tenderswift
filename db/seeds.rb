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

country = Country.create!(name: 'Ghana')

RequestForTender.create!(project_name: 'East Legon Communication Tower',
                        deadline: Time.current + 7.days,
                        country: country,
                        city: 'Accra',
                        description: 'This RFP is soliciting proposals from qualified contractors, preferably located within the aforementioned region, with demonstrated, relevant experience for all permitting, site development, preparation, erection and installation of small footprint, self supporting, guyed communication towers and related wireless communication equipment. Quotes should include the cost of purchase and installation of the related wireless radio communication equipment. Proposals must include guyed tower with the capability of accommodating the placement of four (4) single vertical antenna (tenant) spaces for communication equipment which includes the placement of four (4) 11’ microwave dishes. The entire project must be built to completion and billed no later than July 31. Successful proposals must acknowledge.',
                        budget: '200000',
                        quantity_surveyor: quantity_surveyor)