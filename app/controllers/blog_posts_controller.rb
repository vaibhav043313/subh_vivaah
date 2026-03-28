class BlogPostsController < ApplicationController
  def index
    @posts = BlogPost.published
  end

  def show
    @post = BlogPost.published.find_by!(slug: params[:slug])
  end
end
