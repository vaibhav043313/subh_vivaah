# frozen_string_literal: true

ActiveAdmin.register BlogPost do
  permit_params :title, :slug, :excerpt, :body, :published_at

  controller do
    def scoped_collection
      super.order(Arel.sql("COALESCE(published_at, blog_posts.created_at) DESC"))
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :published_at
    column :created_at
    actions
  end

  filter :title
  filter :slug
  filter :published_at
  filter :created_at

  show do
    attributes_table do
      row :id
      row :title
      row :slug
      row :excerpt
      row(:body) { |post| simple_format(post.body.to_s) }
      row :published_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug
      f.input :excerpt
      f.input :body
      f.input :published_at
    end
    f.actions
  end
end
