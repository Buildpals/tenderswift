class RequestForTender < ApplicationRecord
  include ActionView::Helpers::DateHelper

  monetize :budget_cents, allow_nil: true

  scope :submitted, -> {where(submitted: true)}
  scope :not_submitted, -> {where(submitted: false)}

  has_many :boqs, inverse_of: :request_for_tender,
           dependent: :destroy

  belongs_to :quantity_surveyor

  belongs_to :country

  has_one :winner

  has_many :questions, dependent: :destroy, inverse_of: :request_for_tender
  accepts_nested_attributes_for :questions,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :participants, dependent: :destroy
  accepts_nested_attributes_for :participants,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :project_documents, dependent: :destroy
  accepts_nested_attributes_for :project_documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_one :excel, dependent: :destroy
  accepts_nested_attributes_for :excel,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_one :chatroom, dependent: :destroy

  validates :project_name, presence: true

  validates :deadline, presence: true

  def boq
    boqs.last
  end

  def name
    "##{id} #{project_name}"
  end

  def project_owners_name
    quantity_surveyor.full_name
  end

  def project_owners_company_name
    quantity_surveyor.company_name
  end

  def project_owners_company_logo
    quantity_surveyor.company_logo
  end

  def project_owners_phone_number
    quantity_surveyor.phone_number
  end

  def project_owners_email
    quantity_surveyor.email
  end

  def project_deadline
    self.deadline
  end

  def project_description
    self.description
  end

  def project_location
    "#{city.present? ? city : 'N/A' }, #{country.name}"
  end

  def status
    if !submitted?
      'not submitted'
    else
      if deadline.past?
        'ended'
      else
        "#{time_left} left"
      end
    end
  end

  def time_left
    distance_of_time_in_words(Time.current, deadline)
  end

  def deadline_over?
    Time.current > deadline
  end

  def create_blank_boq
    boq = Boq.new(request_for_tender: self, name: name)
    page = boq.pages.build(name: 'Sheet 1')
    30.times { |i| page.items.build(boq: boq, item_type: 'item', priority: i)}
    boq.save!
  end

  def get_disqualified_contractors
    disqualified_participants = Array.new
    self.participants.lazy.each do |participant|
      unless self.winner.auth_token.eql?(participant.auth_token)
        disqualified_participants.push(participant)
      end
    end
    disqualified_participants
  end

end