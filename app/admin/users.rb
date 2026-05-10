# frozen_string_literal: true

ActiveAdmin.register User do
  actions :index, :show, :edit, :update

  permit_params :premium, :phone_number, role_ids: []

  index do
    selectable_column
    id_column
    column :email
    column(:roles) { |u| u.roles.order(:key).map(&:key).join(", ") }
    column :premium
    column :phone_number
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :roles_id_in, as: :select, multiple: true, collection: -> { Role.order(:key).map { |r| [ r.name, r.id ] } }
  filter :premium
  filter :created_at

  show do
    attributes_table do
      row :id
      row :email
      row(:roles) { resource.roles.order(:key).map(&:name).join(", ") }
      row :premium
      row :phone_number
      row :status
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :created_at
      row :updated_at
    end

    panel "Profile" do
      if resource.profile
        para link_to("Profile ##{resource.profile.id}", admin_profile_path(resource.profile))
      else
        para "No profile"
      end
    end

    panel "Preference" do
      if resource.preference
        attributes_table_for resource.preference do
          row :id
          row :gender
          row :min_age
          row :max_age
          row :religion
          row :city
        end
      else
        para "No preference"
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :role_ids,
              as: :check_boxes,
              label: "Roles",
              collection: Role.order(:key).map { |r| [ r.name, r.id ] }
      f.input :premium
      f.input :phone_number
    end
    f.actions
  end
end
