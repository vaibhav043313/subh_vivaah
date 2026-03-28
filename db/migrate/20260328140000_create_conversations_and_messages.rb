class CreateConversationsAndMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.references :user_lower, null: false, foreign_key: { to_table: :users }
      t.references :user_higher, null: false, foreign_key: { to_table: :users }
      t.datetime :last_message_at
      t.string :last_message_body, limit: 240

      t.timestamps
    end

    add_index :conversations, %i[user_lower_id user_higher_id], unique: true

    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.text :body, null: false
      t.datetime :read_at

      t.timestamps
    end

    add_index :messages, %i[conversation_id created_at]
  end
end
