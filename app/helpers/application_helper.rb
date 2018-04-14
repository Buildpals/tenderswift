# frozen_string_literal: true

module ApplicationHelper
  require 'net/http'

  def working_url?(url_str)
    return false if url_str.nil?
    uri = URI.parse(URI.encode(url_str))
    if uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      true
    else
      false
    end
  end

  def current_month
    month = Time.now.strftime('%m')
    month = month.to_i + 1
    get_month(month)
  end

  def get_month(index)
    months = %w[January February March April May June July August September October November December]
    months[index]
  end

  def current_year
    Time.now.strftime('%Y')
  end

  def time_to_deadline(deadline)
    distance_of_time_in_words_to_now(deadline)
  end
end
