class SurveysController < ApplicationController


  def index
    surveys = Survey.all.includes(:user).select("surveys.*, (SELECT COUNT(*) FROM survey_answers WHERE survey_answers.survey_id = surveys.id) AS survey_answers_count, (SELECT COUNT(*) FROM favorite_surveys WHERE favorite_surveys.survey_id = surveys.id) AS favorite_surveys_count")
    if surveys
      render json: surveys, include: "user"
    else
      render json: surveys.errors
    end
  end

  def show
    survey = Survey.includes(:user).find_by(id: params[:id])
    favorite_surveys = FavoriteSurvey.where(survey_id: survey.id)
    favorite_surveys_count = favorite_surveys.count
    if survey
      render json: {
        survey: survey.as_json(include: :user),
        favorite_surveys_count: favorite_surveys_count
      }
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

  def close_survey
    current_user = User.find_by(id: params[:user_id])
    survey = Survey.find_by(id: params[:id])
    author = survey.user
    if validate_authorship(current_user, author)
      survey.status = 1
      if survey.save
        head :ok
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def is_favorite
    current_user = User.find_by(id: params[:user_id])
    survey = Survey.find_by(id: params[:id])
    favorite_survey = FavoriteSurvey.find_by(user_id: current_user.id, survey_id: survey.id) if current_user
    if favorite_survey
      render json: { is_favorite: true, favorite_survey_id: favorite_survey.id }
    else
      render json: false
    end

  end

  private

    def survey_params
      params.require(:survey).permit(:title, :content, :genre, :option1, :option2, :option3, :option4, :image, :status, :user_id)
    end
end
