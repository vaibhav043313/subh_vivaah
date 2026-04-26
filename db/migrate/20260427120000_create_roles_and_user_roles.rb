# frozen_string_literal: true

class CreateRolesAndUserRoles < ActiveRecord::Migration[8.1]
  class MigrationRole < ActiveRecord::Base
    self.table_name = "roles"
  end

  def up
    create_table :roles do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.timestamps
    end
    add_index :roles, :key, unique: true

    create_table :user_roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.timestamps
    end
    add_index :user_roles, %i[user_id role_id], unique: true

    remove_column :users, :role, if_exists: true
    remove_column :users, :admin, if_exists: true

    now = Time.current
    MigrationRole.insert_all!([
      { key: "member", name: "Member", created_at: now, updated_at: now },
      { key: "admin", name: "Administrator", created_at: now, updated_at: now }
    ])
  end

  def down
    drop_table :user_roles, if_exists: true
    drop_table :roles, if_exists: true
  end
end
