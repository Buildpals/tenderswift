require "rails_helper"

RSpec.feature "Contractor Authentication", :type => :feature do
  scenario "Contractor signs up" do
    visit "/contractors/sign_up"

    fill_in "Your name", :with => "Kwaku Boateng"
    fill_in "Email address", :with => "agogo@gmail.com"
    fill_in "Phone number", :with => "050925831"
    fill_in "Company name", :with => "Yahgo Inc"
    fill_in "Password", :with => "playoffs2"
    fill_in "Password confirmation", :with => "playoffs2"
    click_button "Sign up"

    find('body').has_content?("Welcome! You have signed up successfully.")
  end


  scenario "Contractor sign in" do
    visit "/contractors/sign_in"

    fill_in "Email address", :with => "agogo@gmail.com"
    fill_in "Password", :with => "playoffs2"
    click_button "Log in"

    find('body').has_content?("Signed in successfully.")
  end

end