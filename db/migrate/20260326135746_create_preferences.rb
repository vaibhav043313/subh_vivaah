class CreatePreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :preferences do |t|
      t.references :user, null: false, foreign_key: true
      
      t.integer :min_age
      t.integer :max_age
      t.integer :gender
      t.string :religion
      t.string :city

      t.timestamps
    end

    add_index :preferences, :gender
    add_index :preferences, :religion
  end
end
