# frozen_string_literal: true

ActiveAdmin.register Subscription do
  actions :index, :show, :edit, :update

  permit_params :plan_key, :status, :starts_on, :ends_on

  controller do
    def scoped_collection
      super.includes(:user)
    end
  end

  index do
    selectable_column
    id_column
    column(:user) { |s| link_to(s.user.email, admin_user_path(s.user)) }
    column :plan_key
    column :status
    column :starts_on
    column :ends_on
    column :created_at
    actions
  end

  filter :user
  filter :plan_key
  filter :status
  filter :created_at

  show do
    attributes_table do
      row :id
      row(:user) { |s| link_to(s.user.email, admin_user_path(s.user)) }
      row :plan_key
      row :status
      row :starts_on
      row :ends_on
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :plan_key
      f.input :status
      f.input :starts_on
      f.input :ends_on
    end
    f.actions
  end
end
