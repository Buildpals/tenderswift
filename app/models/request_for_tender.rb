class RequestForTender < ApplicationRecord
  include ActionView::Helpers::DateHelper

  scope :submitted, -> {where(submitted: true)}
  scope :not_submitted, -> {where(submitted: false)}

  has_one :boq, inverse_of: :request_for_tender,
          dependent: :destroy

  belongs_to :quantity_surveyor

  belongs_to :country

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

  validates :project_name, presence: true

  validates :deadline, presence: true

  def name
    "##{id} #{project_name}"
  end

  def project_owners_name
    quantity_surveyor.company_name
  end

  def project_owners_phone_number
    quantity_surveyor.phone_number
  end

  def project_owners_email
    quantity_surveyor.email
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

  def create_blank_boq
    boq = Boq.new(request_for_tender: self, name: name)
    page = boq.pages.build(name: 'Sheet 1')
    30.times {page.items.build(boq: boq)}
    boq.save!
  end

end
