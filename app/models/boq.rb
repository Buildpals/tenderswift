class Boq < ApplicationRecord
  belongs_to :request_for_tender

  has_many :pages, dependent: :destroy, autosave: true

  has_many :items, dependent: :destroy, autosave: true

  has_many :tags, dependent: :destroy, autosave: true

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


  private

  


end
