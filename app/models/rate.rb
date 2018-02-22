class Rate < ApplicationRecord
    belongs_to :participant, inverse_of: :rates
end
