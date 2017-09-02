class Boq < ApplicationRecord

  belongs_to :request_for_tender

  has_many :pages, dependent: :destroy, autosave: true

  validates :name, presence: true


  def get_items
    items = Array.new
    self.pages.each {|page|
      page.sections.each {|section|
        section.items.each {|item|
          items << item
        }
      }
    }
    items
  end


  def get_total_cost_of_each_bid(items = Array.new)
    total_of_bids_hash = Hash.new(0)
    items.each {|i|
      i.filled_items.each {|filled_item|
        total_of_bids_hash[filled_item.participant.phone_number] =
            total_of_bids_hash[filled_item.participant.phone_number] +
                filled_item.amount
      }
    }
    total_of_bids_hash
  end

  #{
  #"0656754": "455",
  #"9069864": "2334",
  #"0659896": "53535"
  #}
  #total_cost

  #items have filled_items
  #a filled_item have the participant details

  #def get_break_down(total_cost_of_bid = 000.00, items = Array.new)
  #break_down = Hash.new(0)
  #items.each { |item|
  #item.filled_items.each { |filled_item|
  #break_down[filled_item.participant.phone_number] = Hash.new
  #}
  #}
  #break_down
  #end

  #{
  #"08978765": {
  #"materails": "54548",
  #"metals": "5787845"
  #},
  #"98089787": {
  #"material": "4353",
  #"metals": "545"
  #}
  #}

  private

  def self.get_percentage_of_total_cost(cost = 0, total_cost = 0)
    cost / total_cost * 100
  end

  def self.get_section_total_cost(section)
    cost = 0
    section.items.each {|item|
      cost = cost.to_f + item.amount.to_f
    }
    cost
  end
  #{
  #material: 20%,
  #concrete: 10%,
  #sand: 50%,
  #equipment: 20%
  #}

end