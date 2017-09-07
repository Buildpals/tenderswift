class AddCompanyNameToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :company_name, :string
  end
end
