class UsersController < ApplicationController
  def show
    def edit # ユーザー編集機能
      @user = User.find(params[:id])
    end

    def update # ユーザー更新機能
      @user = User.find(params[:id])
      @user.update(update_params)
    end
  end

  private
  def update_params
    params.require(:user).permit(:email, :nickname)
  end
end