class AddSiteFeaturesTables < ActiveRecord::Migration[8.1]
  def change
    create_table :contact_messages do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :subject
      t.text :body, null: false

      t.timestamps
    end

    create_table :feedback_submissions do |t|
      t.references :user, null: true, foreign_key: true
      t.string :email
      t.string :category, null: false, default: "general"
      t.text :body, null: false

      t.timestamps
    end

    create_table :blog_posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :excerpt
      t.text :body, null: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :blog_posts, :slug, unique: true

    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :actor, null: true, foreign_key: { to_table: :users }
      t.string :kind, null: false
      t.string :title, null: false
      t.text :body
      t.datetime :read_at
      t.references :notifiable, polymorphic: true

      t.timestamps
    end

    add_index :notifications, [ :user_id, :read_at ]
    add_index :notifications, [ :user_id, :created_at ]

    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "INR"
      t.string :plan_name
      t.string :status, null: false, default: "paid"
      t.string :description
      t.datetime :paid_at
      t.string :external_reference

      t.timestamps
    end

    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :plan_key, null: false
      t.string :status, null: false, default: "active"
      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end

    add_index :subscriptions, [ :user_id, :status ]
  end
end
