class UsersController < ApplicationController

  def index
    users = User.all
    if users
      render json: users
    else
      render json: users.errors
    end
  end

  def show
    # 渡されたパラメータとuidを照合する
    user = User.find_by(uid: params[:id])
    if user
      render json: user
    else
      render json: user.errors
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: user.errors
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :uid)
    end

end
