class QuestionsController < ApplicationController

  include ImageCompressionConcern

  def index
    book = Book.find_by(id: params[:book_id])
    questions = book.questions.includes(:user)

    questions_with_images = questions.map do |question|
      question_data = question.as_json
      if question.image.attached?
        question_data["image"] = rails_blob_url(question.image)
      end

      if question.book.image.attached?
        book_data = question.book.as_json
        book_data["image"] = rails_blob_url(question.book.image)
        question_data["book"] = book_data
      else
        book_data = question.book.as_json
        question_data["book"] = book_data
      end

      if question.user.image.attached?
        user_data = question.user.as_json
        user_data["image"] = rails_blob_url(question.user.image)
        question_data["user"] = user_data
      else
        user_data = question.user.as_json
        question_data["user"] = user_data
      end

      question_data
    end

    if questions_with_images
      render json: questions_with_images
    else
      render json: questions_with_images.errors
    end
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])
    book = Book.find_by(id: params[:book_id])
    question = Question.includes(:user).find_by(id: params[:id])
    favorite_questions = FavoriteQuestion.where(question_id: question.id)
    favorite_questions_count = favorite_questions.count
    if question.image.attached?
      image_url = rails_blob_url(question.image)
      # image_url = rails_representation_url(question.image.variant(resize_to_fill: [100, 100]))
    end
      question_json = question.as_json(include: :user).merge(image: image_url)
    if question
      render json: {
        book: book,
        question: question_json,
        favorite_questions_count: favorite_questions_count
      }
      if current_user && !exist_question_browsing_history?(current_user, question)
        save_question_browsing_history(current_user, question)
      end
    else
      render json: question.errors
    end
  end

  def create
    current_user = User.find_by(id: params[:question][:user_id])
    book = Book.find_by(id: params[:question][:book_id])
    question = current_user.questions.build(question_params)
    # if params[:question][:image]
    #   compressed_image = compress_image(params[:question][:image])
    #   question.image = compressed_image
    # end

    question.book_id = book.id
    if question.save
      render json: question, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def update
    current_user = User.find_by(id: params[:question][:user_id])
    question = Question.find_by(id: params[:id])
    author = question.user
    if validate_authorship(current_user, author)
      if question.update(question_params)
        image_url = question.image.attached? ? rails_blob_url(question.image) : nil
        render json: { question: question, image_url: image_url }, status: 200
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    question = Question.find_by(id: params[:id])
    author = question.user
    if validate_authorship(current_user, author)
      if question.destroy
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
    question = Question.find_by(id: params[:question_id])
    favorite_question = FavoriteQuestion.find_by(user_id: current_user.id, question_id: question.id) if current_user
    if favorite_question
      render json: { is_favorite: true, favorite_question_id: favorite_question.id }
    else
      render json: false
    end
  end

  def all_questions
    questions = Question.includes(:user, :book).select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")

    questions_with_images = questions.map do |question|
      question_data = question.as_json
      if question.image.attached?
        question_data["image"] = rails_blob_url(question.image)
      end

      if question.book.image.attached?
        book_data = question.book.as_json
        book_data["image"] = rails_blob_url(question.book.image)
        question_data["book"] = book_data
      else
        book_data = question.book.as_json
        question_data["book"] = book_data
      end

      if question.user.image.attached?
        user_data = question.user.as_json
        user_data["image"] = rails_blob_url(question.user.image)
        question_data["user"] = user_data
      else
        user_data = question.user.as_json
        question_data["user"] = user_data
      end

      question_data
    end

    if questions_with_images
      render json: questions_with_images
    else
      render jso: questions_with_images.errors
    end
  end

  def search_questions
    search_questions_keyword = params[:searchQuestionsKeyword]
    questions = Question.includes(:user, :book)
                        .select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
                        .where("title LIKE ?", "%#{search_questions_keyword}%")
                        .or(Question.where("content LIKE ?", "%#{search_questions_keyword}%"))
                        .or(Question.where("subject LIKE ?", "%#{search_questions_keyword}%"))
    questions_count = questions.length
    if questions
      render json: {
        questions: questions.as_json(include: [:user, :book]),
        questions_count: questions_count
      }
    else
      render json: { error: "検索結果がありません" }
    end
  end

  def check_existence
    book = Book.find_by(id: params[:book_id])
    question = Question.find_by(id: params[:id])
    if book && question
      head :ok
    else
      head :not_found
    end
  end


  private

    def question_params
      params.require(:question).permit(:title, :content, :subject, :user_id, :book_id, :image)
    end

    def exist_question_browsing_history?(current_user, question)
      current_user.watched_questions.include?(question)
    end

    def save_question_browsing_history(current_user, question)
      question_browsing_histories = BrowsingHistory.where(user_id: current_user.id).where.not(question_id: nil)
      max_browsing_histories = 10
      if question_browsing_histories.count >= max_browsing_histories
        question_browsing_histories.first.destroy
        current_user.browsing_histories.create(question_id: question.id)
      else
        current_user.browsing_histories.create(question_id: question.id)
      end
    end

end
