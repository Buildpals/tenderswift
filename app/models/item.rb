class Item < ApplicationRecord

    belongs_to :section

    
    validates :name, presence: true

    validates :description, presence: true
    
    validates :quantity, presence: true
    
    validates :rate, presence: true
    
    validates :amount, presence: true
    
end
