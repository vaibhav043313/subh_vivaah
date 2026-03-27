class AddBrowseFieldsToProfilesAndUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :education, :string
    add_column :profiles, :mother_tongue, :string
    add_column :profiles, :height_cm, :integer
    add_column :profiles, :has_photo, :boolean, default: true, null: false

    add_column :users, :premium, :boolean, default: false, null: false
    add_column :users, :last_seen_at, :datetime
  end
end
