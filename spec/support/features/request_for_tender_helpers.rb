# frozen_string_literal: true

include ActionView::Helpers::DateHelper
module Features

  def user_sees_public_request_for_tender_information(request_for_tender)
    expect(page).to have_content request_for_tender.project_name
    expect(page).to have_content request_for_tender.project_owners_company_name
    expect(page).to have_content request_for_tender.description

    user_sees_project_location(request_for_tender)
    expect(page).to have_content request_for_tender.contract_class
    user_sees_project_currency(request_for_tender)

    user_sees_time_closed(request_for_tender)
    user_sees_tendering_duration(request_for_tender)

    request_for_tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content request_for_tender.tender_instructions
  end

  def user_sees_tendering_duration(request_for_tender)
    text = "#{request_for_tender.published_at
                  .to_date.to_formatted_s(:long_ordinal)} to " \
           "#{request_for_tender.deadline
                  .to_date.to_formatted_s(:long_ordinal)}"
    expect(page).to have_content text
  end

  def user_sees_time_closed(request_for_tender)
    time = distance_of_time_in_words_to_now(request_for_tender.deadline)
    if Time.current > request_for_tender.deadline
      expect(page).to have_content "Time closed #{time}"
    else
      expect(page).to have_content "Time left #{time}"
    end
  end

  def user_sees_project_currency(request_for_tender)
    if request_for_tender.currency == 'USD'
      expect(page).to have_content 'USD - United States Dollar'
    elsif request_for_tender.currency == 'GHS'
      expect(page).to have_content 'GHS - Ghanaian Cedi'
    end
  end

  def user_sees_project_location(request_for_tender)
    c = ISO3166::Country[request_for_tender.country_code]
    country = c.translations[I18n.locale.to_s] || c.name

    if request_for_tender.city.present?
      expect(page).to have_content "#{request_for_tender.city}, #{country}"
    else
      expect(page).to have_content "N/A, #{country}"
    end
  end

  def self.included(base)
    base.send(:include, ActionView::Helpers::DateHelper)
    base.extend(ClassMethods)
  end
end
