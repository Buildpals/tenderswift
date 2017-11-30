class Boq < ApplicationRecord
  belongs_to :request_for_tender, inverse_of: :boqs

  has_many :pages, dependent: :destroy, autosave: true

  has_many :items, dependent: :destroy, autosave: true

  validates :name, presence: true
end
