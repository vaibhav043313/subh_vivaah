# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def index
      scope = User.order(created_at: :desc)
      @users, @total, @page, @total_pages, @per = paginate(scope, per: 30)
    end

    def show
      @user = User.includes(:profile, :preference).find(params[:id])
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(admin_user_params)
        redirect_to admin_user_path(@user), notice: "User updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def admin_user_params
      params.require(:user).permit(:admin, :premium, :phone_number)
    end
  end
end
