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

  def show_other_user
    user = User.find_by(id: params[:id])
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

  def update
    user = User.find_by(id: params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: user.errors
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :uid, :introduction, :first_choice_school, :second_choice_school, :third_choice_school)
    end

end
