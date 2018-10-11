# frozen_string_literal: true

module RequestForTendersHelper
  include ActionView::Helpers::DateHelper

  def status(request_for_tender)
    if request_for_tender.published?
      if request_for_tender.deadline.past?
        'ended'
      else
        "#{distance_of_time_in_words_to_now request_for_tender.deadline} left"
      end
    else
      request_for_tender.submitted? ? 'pending...' : 'draft'
    end
  end

  def deadline_over?(request_for_tender)
    Time.current > request_for_tender.deadline
  end

  def project_location(request_for_tender)
    if request_for_tender.country_code.present?
      c = ISO3166::Country[request_for_tender.country_code]
      country = c.translations[I18n.locale.to_s] || c.name
    else
      country = ""
    end

    "#{request_for_tender.city.present? ? request_for_tender.city : 'N/A'}, #{country}"
  end

  def time_to_deadline(request_for_tender)
    distance_of_time_in_words_to_now(request_for_tender.deadline)
  end

  def distance_from_deadline(request_for_tender)
    time = distance_of_time_in_words_to_now(request_for_tender.deadline)
    if deadline_over? request_for_tender
      "#{time} since deadline"
    else
      "#{time} to deadline"
    end
  end

  def purchase_url(request_for_tender)
    if Rails.env.development? || Rails.env.test?
      purchase_tender_url(request_for_tender)
    else
      "https://public.tenderswift.com/#{request_for_tender.id}"
    end
  end
end
