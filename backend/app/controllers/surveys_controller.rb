class SurveysController < ApplicationController

  include SharedActions::AttachImage
  include SharedActions::DateTime


  def index
    surveys = Survey.all
                    .includes( user: { image_attachment: :blob })
                    .select("surveys.*, (SELECT COUNT(*) FROM survey_answers WHERE survey_answers.survey_id = surveys.id) AS survey_answers_count, (SELECT COUNT(*) FROM favorite_surveys WHERE favorite_surveys.survey_id = surveys.id) AS favorite_surveys_count")
    surveys_with_images = attach_image_to_surveys(surveys)
    if surveys_with_images
      render json: surveys_with_images
    else
      render json: surveys_with_images.errors
    end
  end

  def show
    current_user = User.find_by(id: params[:user_id])
    survey = Survey.includes(:user).find_by(id: params[:id])
    favorite_surveys = FavoriteSurvey.where(survey_id: survey.id)
    favorite_surveys_count = favorite_surveys.count
    if survey.image.attached?
      image_url = rails_blob_url(survey.image)
    end
      survey_json = survey.as_json(include: :user).merge(image: image_url)

    if survey
      render json: {
        survey: survey_json,
        favorite_surveys_count: favorite_surveys_count
      }
      if current_user && !exist_survey_browsing_history?(current_user, survey)
        save_survey_browsing_history(current_user, survey)
      end
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

  def check_existence
    survey = Survey.find_by(id: params[:id])
    if survey = Survey.find_by(id: params[:id])
      head :ok
    else
      head :not_found
    end
  end


  private

    def survey_params
      params.require(:survey).permit(:title, :content, :genre, :option1, :option2, :option3, :option4, :image, :status, :user_id)
    end

    def exist_survey_browsing_history?(current_user, survey)
      current_user.watched_surveys.include?(survey)
    end

    def save_survey_browsing_history(current_user, survey)
      survey_browsing_histories = BrowsingHistory.where(user_id: current_user.id).where.not(survey_id: nil)
      max_browsing_histories = 10
      if survey_browsing_histories.count >= max_browsing_histories
        survey_browsing_histories.first.destroy
        current_user.browsing_histories.create(survey_id: survey.id)
      else
        current_user.browsing_histories.create(survey_id: survey.id)
      end
    end


end
