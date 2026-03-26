class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true

      # Basic Info
      t.string :first_name, null: false
      t.string :last_name
      t.date :date_of_birth, null: false
      t.integer :gender

      # Matrimony-specific
      t.string :religion
      t.string :caste
      t.string :profession
      t.integer :income

      # Location
      t.string :city
      t.string :state
      t.string :country

      # Profile Quality
      t.text :bio
      t.boolean :verified, default: false
      t.integer :completion_score, default: 0

      # Visibility / Privacy
      t.integer :visibility  # public, private, premium_only


      t.timestamps
    end

    add_index :profiles, [:gender, :religion]
    add_index :profiles, [:city, :state, :country]
    add_index :profiles, :profession
  end
end
