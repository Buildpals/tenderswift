class Winner < ApplicationRecord

  belongs_to :request_for_tender

  def self.cast_participant(participant)
    winner = Winner.new
    participant.attributes.each do |key, value|
      case key
      when "email"
        winner.email = value
      when "first_name"
        winner.first_name = value
      when "last_name"
        winner.last_name = value
      when "company_name"
        winner.company_name = value
      when "phone_number"
        winner.phone_number = value
      when "auth_token"
        winner.auth_token = value
      when "request_for_tender"
        winner.request_for_tender = value
      end
    end
    winner
  end

end
