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
      head :no_content
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 200
    else
      render json: user.errors, status: 400
    end
  end

  def update
    user = User.find_by(id: params[:id])
    if user.update(user_params)
      render json: user, status: 200
    else
      render json: user.errors, status: 400
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if !check_admin?(user)
      if user.destroy
        head :no_content
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "このユーザーは削除できません" }, status: 400
    end
  end

  def save_user_memo
    current_user = User.find_by(id: params[:current_user_id])
    memo = params[:memo]
    if current_user.update(memo: memo)
      render json: current_user, status: 200
    else
      render json: current_user.errors, status: 400
    end

  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :uid, :introduction, :first_choice_school, :second_choice_school, :third_choice_school, :memo)
    end

    def check_admin?(user)
      user.admin == true
    end
end
