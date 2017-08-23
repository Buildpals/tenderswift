class Request < ApplicationRecord
  include ActionView::Helpers::DateHelper

  has_and_belongs_to_many :participants, join_table: :participants_requests

  def time_left_to_deadline
    if deadline.past?
      'ended'
    else
      time_left = distance_of_time_in_words(Time.current, deadline)
      "#{time_left} left"
    end
  end

end
