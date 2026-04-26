# frozen_string_literal: true

ActiveAdmin.register ContactMessage do
  actions :index, :show

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :subject
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :created_at

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :subject
      row(:body) { |m| simple_format(m.body.to_s) }
      row :created_at
      row :updated_at
    end
  end
end
