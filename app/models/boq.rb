class Boq < ApplicationRecord

    belongs_to :request

    has_many :pages

    validates :name, presence: true

end
