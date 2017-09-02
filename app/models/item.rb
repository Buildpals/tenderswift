class Item < ApplicationRecord

    belongs_to :section

    has_many :filled_items, dependent: :destroy, autosave: true

    has_many :participants, through: :filled_items, dependent: :destroy, autosave: true
    
    #validates :name, presence: true

    #validates :description, presence: true
    
    #validates :quantity, presence: true
    
    #validates :rate, presence: true
    
    #validates :amount, presence: true
    
end
