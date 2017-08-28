class Boq < ApplicationRecord

    belongs_to :request_for_tender

    has_many :pages, dependent: :destroy, autosave: true

    validates :name, presence: true

end