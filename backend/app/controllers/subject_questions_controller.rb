class SubjectQuestionsController < ApplicationController

  def index
    subject_questions = SubjectQuestion.includes(:user).select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
    if subject_questions
      render json: subject_questions, include: "user"
    else
      render json: subject_questions.errors
    end
  end


  def show
    current_user = User.find_by(id: params[:current_user_id])
    subject_question = SubjectQuestion.includes(:user).find_by(id: params[:id])
    favorite_subject_questions = FavoriteSubjectQuestion.where(subject_question_id: subject_question.id)
    favorite_subject_questions_count = favorite_subject_questions.count
    if subject_question.image.attached?
      image_url = rails_blob_url(subject_question.image)
    end
      subject_question_json = subject_question.as_json(include: :user).merge(image: image_url)
    if subject_question
      render json: {
        subject_question: subject_question_json,
        favorite_subject_questions_count: favorite_subject_questions_count
      }
      if current_user && !exist_subject_question_browsing_history?(current_user, subject_question)
        save_subject_question_browsing_history(current_user, subject_question)
      end
    else
      render json: subject_question.errors
    end
  end


  def create
    current_user = User.find_by(id: params[:subject_question][:user_id])
    subject_question = current_user.subject_questions.build(subject_question_params)
    if subject_question.save
      render json: subject_question, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def update
    current_user = User.find_by(id: params[:subject_question][:user_id])
    subject_question = SubjectQuestion.find_by(id: params[:id])
    author = subject_question.user
    if validate_authorship(current_user, author)
      if subject_question.update(subject_question_params)
        image_url = subject_question.image.attached? ? rails_blob_url(subject_question.image) : nil
        render json: { subject_question: subject_question, image_url: image_url }, status: 200
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    subject_question = SubjectQuestion.find_by(id: params[:id])
    author = subject_question.user
    if validate_authorship(current_user, author)
      if subject_question.destroy
        head :no_content
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def is_favorite
    current_user = User.find_by(id: params[:user_id])
    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    favorite_subject_question = FavoriteSubjectQuestion.find_by(user_id: current_user.id, subject_question_id: subject_question.id) if current_user
    if favorite_subject_question
      render json: { is_favorite: true, favorite_subject_question_id: favorite_subject_question.id }
    else
      render json: false
    end
  end

  def search_subject_questions
    search_subject_questions_keyword = params[:searchSubjectQuestionsKeyword]
    subject_questions = SubjectQuestion.includes(:user)
                        .select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
                        .where("title LIKE ?", "%#{search_subject_questions_keyword}%")
                        .or(SubjectQuestion.where("content LIKE ?", "%#{search_subject_questions_keyword}%"))
                        .or(SubjectQuestion.where("subject LIKE ?", "%#{search_subject_questions_keyword}%"))
    subject_questions_count = subject_questions.length
    if subject_questions
      render json: {
        subject_questions: subject_questions.as_json(include: :user),
        subject_questions_count: subject_questions_count
      }
    else
      render json: { error: "検索結果がありません" }
    end
  end

  def questions_to_specific_subject
    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    subject_questions_to_specific_subject = SubjectQuestion.where(subject: subject_question.subject)
    if subject_questions_to_specific_subject
      render json: subject_questions_to_specific_subject
    else
      render json: subject_questions_to_specific_subject.errors
    end
  end

  def check_existence
    subject_question = SubjectQuestion.find_by(id: params[:id])
    if subject_question
      head :ok
    else
      head :not_found
    end
  end

  private

    def subject_question_params
      params.require(:subject_question).permit(:title, :content, :subject, :user_id, :image)
    end

    def exist_subject_question_browsing_history?(current_user, subject_question)
      current_user.watched_subject_questions.include?(subject_question)
    end

    def save_subject_question_browsing_history(current_user, subject_question)
      subject_question_browsing_histories = BrowsingHistory.where(user_id: current_user.id).where.not(subject_question_id: nil)
      max_browsing_histories = 10
      if subject_question_browsing_histories.count >= max_browsing_histories
        subject_question_browsing_histories.first.destroy
        current_user.browsing_histories.create(subject_question_id: subject_question.id)
      else
        current_user.browsing_histories.create(subject_question_id: subject_question.id)
      end
    end



end
