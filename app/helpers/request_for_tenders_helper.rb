# frozen_string_literal: true

module RequestForTendersHelper
  include ActionView::Helpers::DateHelper

  def status(request_for_tender)
    if !request_for_tender.published?
      'not published'
    else
      if request_for_tender.deadline.past?
        'ended'
      else
        "#{ distance_of_time_in_words_to_now request_for_tender.deadline} left"
      end
    end
  end

  def contract_class(request_for_tender)
    # TODO: Return proper contract class
    'D1, K1'
  end

  def deadline_over?(request_for_tender)
    Time.current > request_for_tender.deadline
  end

  def project_location(request_for_tender)
    c = ISO3166::Country[request_for_tender.country_code]
    country = c.translations[I18n.locale.to_s] || c.name
    "#{request_for_tender.city.present? ? request_for_tender.city : 'N/A'}, #{country}"
  end

  def project_currency(request_for_tender)
    if request_for_tender.currency == 'USD'
      'USD - United States Dollar'
    elsif request_for_tender.currency == 'GHS'
      'GHS - Ghanaian Cedi'
    end
  end

  def project_currency_symbol(request_for_tender)
    request_for_tender.currency == 'USD' ? '$' : 'GH₵'
  end

  def time_to_deadline(request_for_tender)
    distance_of_time_in_words_to_now(request_for_tender.deadline)
  end

  def purchase_url(request_for_tender)
    if Rails.env.development? || Rails.env.test?
      purchase_tender_url(request_for_tender)
    else
      "https://public.tenderswift.com/#{request_for_tender.id}"
    end
  end
end
