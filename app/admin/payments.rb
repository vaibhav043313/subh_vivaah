# frozen_string_literal: true

ActiveAdmin.register Payment do
  actions :index, :show

  controller do
    def scoped_collection
      super.includes(:user)
    end
  end

  index do
    selectable_column
    id_column
    column(:user) { |p| link_to(p.user.email, admin_user_path(p.user)) }
    column(:amount) { |p| "#{p.amount_rupees} #{p.currency}" }
    column :plan_name
    column :status
    column :paid_at
    column :created_at
    actions
  end

  filter :user
  filter :status
  filter :currency
  filter :created_at

  show do
    attributes_table do
      row :id
      row(:user) { |p| link_to(p.user.email, admin_user_path(p.user)) }
      row(:amount_rupees) { |p| p.amount_rupees }
      row :amount_cents
      row :currency
      row :plan_name
      row :status
      row :description
      row :external_reference
      row :paid_at
      row :created_at
      row :updated_at
    end
  end
end
