class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :matched_user_id, null: false

      t.float :score, default: 0
      t.integer :status, default: 0 # pending, liked, rejected

      t.timestamps
    end

    add_index :matches, [ :user_id, :matched_user_id ], unique: true
    add_index :matches, :score
  end
end
