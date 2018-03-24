require 'rails_helper'

RSpec.feature 'Quantity surveyors can create new request for tender' do
  let!(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }

  before do
    login_as(quantity_surveyor)
  end

  scenario 'with valid attributes' do
    visit '/'

    click_link 'Create Request For Tender'

    expect(page).to have_content 'Untitled Project #'
  end
end
