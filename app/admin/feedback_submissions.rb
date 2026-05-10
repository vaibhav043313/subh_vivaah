# frozen_string_literal: true

ActiveAdmin.register FeedbackSubmission do
  actions :index, :show

  controller do
    def scoped_collection
      super.includes(:user)
    end
  end

  index do
    selectable_column
    id_column
    column :category
    column(:user) do |s|
      s.user ? link_to(s.user.email, admin_user_path(s.user)) : "—"
    end
    column :email
    column :created_at
    actions
  end

  filter :category
  filter :email
  filter :created_at

  show do
    attributes_table do
      row :id
      row :category
      row(:user) do |s|
        s.user ? link_to(s.user.email, admin_user_path(s.user)) : "—"
      end
      row :email
      row(:body) { |s| simple_format(s.body.to_s) }
      row :created_at
      row :updated_at
    end
  end
end
