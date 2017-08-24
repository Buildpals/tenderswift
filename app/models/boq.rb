class Boq < ApplicationRecord

    belongs_to :request

    has_many :pages

end
