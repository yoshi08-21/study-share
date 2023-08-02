class SurveysController < ApplicationController


  def index
    surveys = Survey.all.includes(:user)
    if surveys
      render json: surveys, include: "user"
    else
      render json: surveys.errors
    end
  end

  def show
    survey = Survey.includes(:user).find_by(id: params[:id])
    # 別テーブルから回答情報を取得する必要がある
    if survey
      render json: survey, include: "user"
    else
      render json: survey.errors
    end
  end

  def create
    current_user = User.find_by(id: params[:survey][:user_id])
    survey = current_user.surveys.build(survey_params)
    if survey.save
      render json: survey
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    survey = Survey.find_by(id: params[:id])
    author = survey.user
    if validate_authorship(current_user, author)
      if survey.destroy
        head :no_content
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end


  private

    def survey_params
      params.require(:survey).permit(:title, :content, :genre, :option1, :option2, :option3, :option4, :image, :status, :user_id)
    end
end
