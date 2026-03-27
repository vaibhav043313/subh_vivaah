class AddMaritalStatusToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :marital_status, :string
  end
end
