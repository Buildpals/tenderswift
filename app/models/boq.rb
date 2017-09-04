class Boq < ApplicationRecord
  belongs_to :request_for_tender

  has_many :pages, dependent: :destroy, autosave: true

  validates :name, presence: true

  # Todo includes
  def get_items
    items = []
    pages.each do |page|
      page.sections.each do |section|
        section.items.each do |item|
          items << item
        end
      end
    end
    items
  end

  # TODO: fix N+1 problem here with includes
  # coded runs too many queries
  def get_total_cost_of_each_bid(items = [])
    total_of_bids_hash = Hash.new(0)
    items.each do |i|
      i.filled_items.each do |filled_item|
        total_of_bids_hash[filled_item.participant.phone_number] =
            total_of_bids_hash[filled_item.participant.phone_number] +
                eval(filled_item.amount)
      end
    end
    total_of_bids_hash
  end

  def get_section_breakdown(participant)
    participants = Hash.new(0)
    sections_cost = Hash.new(0)
    request_for_tender.participants.each do |current_participant|
      items.each do |item|
        item.filled_items.each do |filled_item|
          # current_participant = filled_item.participant.phone_number
          if item.section.name.eql?(filled_item.item.section.name) && current_participant.phone_number.eql?(filled_item.participant.phone_number)
            sections_cost[filled_item.item.section.name] =
                sections_cost[filled_item.item.section.name] +
                    # TODO: The use of eval is a serious security risk. Please change it
                    eval(filled_item.amount)
          end
          participants[filled_item.participant.phone_number] = sections_cost
        end
      end
    end
    participants
  end

  def section_total(participant)
    section_total = 0
    pages.sections.each do |section|
      section_total += section.total
    end
  end

  # {
  # "08978765": {
  # "materails": "54548",
  # "metals": "5787845"
  # },
  # "98089787": {
  # "material": "4353",
  # "metals": "545"
  # }
  # }

  private

  def self.get_percentage_of_total_cost(cost = 0, total_cost = 0)
    cost / total_cost * 100
  end

  def self.get_section_total_cost(section)
    cost = 0
    section.items.each do |item|
      cost = cost.to_f + item.amount.to_f
    end
    cost
  end
  # {
  # material: 20%,
  # concrete: 10%,
  # sand: 50%,
  # equipment: 20%
  # }
end
