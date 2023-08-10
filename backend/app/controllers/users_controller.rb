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
    user = User.find_by(id: params[:id])
    if user.image.attached?
      image_url = rails_blob_url(user.image)
    end
      user_json = user.as_json.merge(image: image_url)
    if user
      render json: user_json
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
      s3_object = Aws::S3::Resource.new.bucket('study-feedback-bucket').object('default_user_image.png')

      temp_file = Tempfile.new('downloaded_image', binmode: true)
      temp_file.write(s3_object.get.body.read)
      temp_file.rewind

      user.image.attach(io: temp_file, filename: 'default_image.jpg', content_type: 'image/jpeg')
      temp_file.close
      temp_file.unlink

      render json: user, status: 200
    else
      render json: user.errors, status: 400
    end
  end

  def update
    user = User.find_by(id: params[:id])
    if user.update(user_params)
      image_url = user.image.attached? ? rails_blob_url(user.image) : nil
      render json: { user: user, image_url: image_url }, status: 200
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

  def check_existence
    user = User.find_by(id: params[:id])
    if user
      head :ok
    else
      head :not_found
    end
  end


  def find_user_by_uid
    user = User.find_by(uid: params[:uid])
    if user
      render json: user
    else
      render json: user.errors
    end
  end



  private

    def user_params
      params.require(:user).permit(:name, :email, :uid, :introduction, :first_choice_school, :second_choice_school, :third_choice_school, :memo, :image)
    end

    def check_admin?(user)
      user.admin == true
    end
end
