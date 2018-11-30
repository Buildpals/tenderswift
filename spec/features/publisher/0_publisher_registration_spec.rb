# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Publisher registration' do
  let(:new_publisher) {FactoryBot.build(:publisher)}

  before :each do
    visit new_publisher_registration_path

    fill_in 'Full name', with: new_publisher.full_name
    fill_in 'Email address', with: new_publisher.email

    click_button 'Sign up'
  end

  it "shows message about confirmation email" do
    expect(page).to have_content('Account successfully created')
  end

  describe "confirmation email" do
    # Include email_spec modules here, not in rails_helper because they
    # conflict with the capybara-email#open_email method which lets us
    # call current_email.click_link below.
    # Re: https://github.com/dockyard/capybara-email/issues/34#issuecomment-49528389
    include EmailSpec::Helpers
    include EmailSpec::Matchers

    # open the most recent email sent to publisher_email
    subject {open_email(new_publisher.email)}

    # Verify email details
    it {is_expected.to deliver_to(new_publisher.email)}
    it {is_expected.to have_body_text(/you can confirm your account/)}
    it {is_expected.to have_body_text(/publishers\/confirmation\?confirmation/)}
    it {is_expected.to have_subject(/Confirmation instructions/)}
  end

  context "when clicking confirmation link in email" do
    before :each do
      open_email(new_publisher.email)
      current_email.click_link 'Confirm my account'
    end

    it "shows confirmation message" do
      expect(page).to have_content('Your email address has been successfully confirmed')
      expect(page).to have_field('Password')
      expect(page).to have_field('Password confirmation')
    end

    it "confirms publisher" do
      publisher = Publisher.find_for_authentication(email: new_publisher.email)
      expect(publisher).to be_confirmed
    end
  end
end
