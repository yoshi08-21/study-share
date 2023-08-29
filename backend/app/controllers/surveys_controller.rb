class SurveysController < ApplicationController

  include SharedActions::AttachImage
  include SharedActions::DateTime


  def index
    surveys = Survey.all
                    .includes( user: { image_attachment: :blob })
                    .select("surveys.*, (SELECT COUNT(*) FROM survey_answers WHERE survey_answers.survey_id = surveys.id) AS survey_answers_count, (SELECT COUNT(*) FROM favorite_surveys WHERE favorite_surveys.survey_id = surveys.id) AS favorite_surveys_count")
    return render json: [] if surveys.blank?

    surveys_with_images = attach_image_to_surveys(surveys)
    render json: surveys_with_images
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])

    survey = Survey.with_attached_image
                    .includes( user: { image_attachment: :blob })
                    .select("surveys.*, (SELECT COUNT(*) FROM survey_answers WHERE survey_answers.survey_id = surveys.id) AS survey_answers_count, (SELECT COUNT(*) FROM favorite_surveys WHERE favorite_surveys.survey_id = surveys.id) AS favorite_surveys_count")
                    .find_by(id: params[:id])
    return head :not_found unless survey
    survey_json = attach_image_to_survey(survey)

    survey_user = survey.user
    survey_user_json = attach_image_to_user(survey_user)

    if current_user && !exist_survey_browsing_history?(current_user, survey)
      save_survey_browsing_history(current_user, survey)
    end

    render json: {
      survey: survey_json,
      survey_user: survey_user_json
    }
  end

  def create
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    survey = current_user.surveys.build(survey_params)
    if survey.save
      render json: survey
    else
      render json: { errors: survey.errors.full_messages }, status: 422
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    survey = Survey.find_by(id: params[:id])
    return head :not_found unless survey

    author = survey.user
    return render json: { error: "権限がありません" }, status: 422 unless validate_authorship(current_user, author)

    if survey.destroy
      head :no_content
    else
      render json: { errors: survey.errors.full_messages }, status: 422
    end
  end

  def close_survey
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    survey = Survey.find_by(id: params[:id])
    return head :not_found unless survey

    author = survey.user
    return render json: { error: "権限がありません" }, status: 422 unless validate_authorship(current_user, author)

    return render json: { error: "アンケートはすでに締め切られています" }, status: 422 if survey.status == true
    survey.status = true

    if survey.save
      head :ok
    else
      render json: { errors: survey.errors.full_messages }, status: 422
    end
  end

  def is_favorite
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    survey = Survey.find_by(id: params[:id])
    return head :not_found unless survey

    favorite_survey = FavoriteSurvey.find_by(user_id: current_user.id, survey_id: survey.id) if current_user
    if favorite_survey
      render json: { is_favorite: true, favorite_survey_id: favorite_survey.id }
    else
      render json: false
    end
  end

  # checkResourceExistence.jsから呼び出し
  def check_existence
    survey = Survey.find_by(id: params[:id])
    return head :not_found unless survey

    head :ok
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
