class Request < ApplicationRecord

    has_one :excel, dependent: :destroy

    has_one :boq, dependent: :destroy, autosave: true

    has_and_belongs_to_many :participants, join_table: :participants_requests, dependent: :destroy

    validates :project_name, presence: true

    validates :deadline, presence: true

    validates :country, presence: true

    validates :city, presence: true
    
    validates :description, presence: true

    validates :budget, presence: true

end
