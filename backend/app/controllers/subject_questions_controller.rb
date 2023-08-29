class SubjectQuestionsController < ApplicationController

  include SharedActions::AttachImage
  include SharedActions::DateTime


  def index
    subject_questions = SubjectQuestion.includes(user: { image_attachment: :blob })
                                        .select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
    return render json: [] if subject_questions.blank?

    subject_questions_with_images = attach_image_to_subject_questions(subject_questions)
    render json: subject_questions_with_images
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])

    subject_question = SubjectQuestion.includes(user: { image_attachment: :blob })
                                      .select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
                                      .find_by(id: params[:id])
    return head :not_found unless subject_question
    subject_question_json = attach_image_to_question(subject_question)
    subject_question_json["created_at"] = format_japanese_time(subject_question.created_at)

    subject_question_user = User.with_attached_image.find_by(id: subject_question.user_id)
    subject_question_user_json = attach_image_to_user(subject_question_user)

    if current_user && !exist_subject_question_browsing_history?(current_user, subject_question)
      save_subject_question_browsing_history(current_user, subject_question)
    end

    render json: {
      subject_question: subject_question_json,
      subject_question_user: subject_question_user_json
    }
  end

  def create
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    subject_question = current_user.subject_questions.build(subject_question_params)
    if subject_question.save
      render json: subject_question, status: 200
    else
      render json: { errors: subject_question.errors.full_messages }, status: 422
    end
  end

  def update
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    subject_question = SubjectQuestion.find_by(id: params[:id])
    return head :not_found unless subject_question

    author = subject_question.user
    return render json: { error: "権限がありません" }, status: 422 unless validate_authorship(current_user, author)

    if subject_question.update(subject_question_params)
      image_url = subject_question.image.attached? ? rails_blob_url(subject_question.image) : nil
      render json: { subject_question: subject_question, image_url: image_url }, status: 200
    else
      render json: { errors: subject_question.errors.full_messages }, status: 422
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    subject_question = SubjectQuestion.find_by(id: params[:id])
    return head :not_found unless subject_question

    author = subject_question.user
    return render json: { error: "権限がありません" }, status: 422 unless validate_authorship(current_user, author)

    if subject_question.destroy
      head :no_content
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def is_favorite
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    return head :not_found unless subject_question

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
    subject_questions_with_images = attach_image_to_subject_questions(subject_questions)

    render json: {
      subject_questions: subject_questions.as_json(include: :user),
      subject_questions_count: subject_questions_count
    }
  end

  # 渡されたidで検索した質問の科目と同じ科目の質問を返す
  def questions_to_specific_subject
    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    return head :not_found unless subject_question

    subject_questions_to_specific_subject = SubjectQuestion.where(subject: subject_question.subject)
    render json: subject_questions_to_specific_subject
  end

  # checkResourceExistence.jsから呼び出し
  def check_existence
    subject_question = SubjectQuestion.find_by(id: params[:id])
    return head :not_found unless subject_question

    head :ok
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
