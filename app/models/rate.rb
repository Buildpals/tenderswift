class Rate < ApplicationRecord
    belongs_to :tender, inverse_of: :rates
end
