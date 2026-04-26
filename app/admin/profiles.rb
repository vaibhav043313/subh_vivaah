# frozen_string_literal: true

ActiveAdmin.register Profile do
  actions :index, :show, :edit, :update

  permit_params :verified, :visibility, :first_name, :last_name, :city, :state, :country, :religion, :gender

  controller do
    def scoped_collection
      super.includes(:user)
    end
  end

  index do
    selectable_column
    id_column
    column(:user) { |p| link_to(p.user.email, admin_user_path(p.user)) }
    column :first_name
    column :last_name
    column :city
    column :verified
    column :visibility
    column :completion_score
    column :updated_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :city
  filter :verified
  filter :visibility
  filter :gender, as: :select, collection: Profile.genders.keys
  filter :updated_at

  show do
    attributes_table do
      row :id
      row(:user) { |p| link_to(p.user.email, admin_user_path(p.user)) }
      row :first_name
      row :last_name
      row :date_of_birth
      row :gender
      row :city
      row :state
      row :country
      row :religion
      row :caste
      row :profession
      row :verified
      row :visibility
      row :completion_score
      row :created_at
      row :updated_at
    end

    panel "Photos" do
      if resource.photos.attached?
        para "#{resource.photos.count} photo(s) attached."
      else
        para "No photos"
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :verified
      f.input :visibility, as: :select, collection: Profile.visibilities.keys
      f.input :first_name
      f.input :last_name
      f.input :city
      f.input :state
      f.input :country
      f.input :religion
      f.input :gender, as: :select, collection: Profile.genders.keys
    end
    f.actions
  end
end
