class Request < ApplicationRecord

    has_one :excel

    has_and_belongs_to_many :participants, join_table: :participants_requests

    validates :project_name, presence: true

    validates :deadline, presence: true

    validates :country, presence: true

    validates :city, presence: true
    
    validates :description, presence: true

    validates :budget, presence: true

end
