class Request < ApplicationRecord
  include ActionView::Helpers::DateHelper

    has_one :excel, dependent: :destroy

    has_one :boq, dependent: :destroy, autosave: true

    has_and_belongs_to_many :participants, join_table: :participants_requests, dependent: :destroy

    validates :project_name, presence: true

    validates :deadline, presence: true

    validates :country, presence: true

    validates :city, presence: true

    validates :description, presence: true

    validates :budget, presence: true

  def time_left_to_deadline
    if deadline.past?
      'ended'
    else
      time_left = distance_of_time_in_words(Time.current, deadline)
      "#{time_left} left"
    end
  end

end
