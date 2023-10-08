class UsersController < ApplicationController

  include SharedActions::AttachImage


  def show
    user = User.with_attached_image.find_by(id: params[:id])
    return head :not_found unless user

    if user.image.attached?
      image_url = rails_blob_url(user.image)
    end
    user_json = user.as_json.merge(image: image_url)

    my_reviews = user.reviews.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob }).select("reviews.*, (SELECT COUNT(*) FROM favorite_reviews WHERE favorite_reviews.review_id = reviews.id) AS favorite_reviews_count")
    my_reviews_with_images = attach_image_to_reviews(my_reviews)
    my_favorite_reviews_count = FavoriteReview.joins(:review).where(review: { user_id: user.id }).count

    my_questions = user.questions.with_attached_image.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob }).select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
    my_questions_with_images = attach_image_to_questions(my_questions)
    my_favorite_questions_count = FavoriteQuestion.joins(:question).where(questions: { user_id: user.id }).count

    my_replies = user.replies.with_attached_image.includes(:question, user: { image_attachment: :blob }).select("replies.*, (SELECT COUNT(*) FROM favorite_replies WHERE favorite_replies.reply_id = replies.id) AS favorite_replies_count")
    my_replies_with_images = attach_image_to_replies(my_replies)
    my_favorite_replies_count = FavoriteReply.joins(:reply).where(reply: { user_id: user.id }).count

    my_subject_questions = user.subject_questions.with_attached_image.includes(user: { image_attachment: :blob }).select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
    my_subject_questions_with_images = attach_image_to_subject_questions(my_subject_questions)
    my_favorite_subject_questions_count = FavoriteSubjectQuestion.joins(:subject_question).where(subject_question: { user_id: user.id }).count

    my_subject_question_replies = user.subject_question_replies.with_attached_image.includes(:subject_question, user: { image_attachment: :blob }).select("subject_question_replies.*, (SELECT COUNT(*) FROM favorite_subject_question_replies WHERE favorite_subject_question_replies.subject_question_reply_id = subject_question_replies.id) AS favorite_subject_question_replies_count")
    my_subject_question_replies_with_images = attach_image_to_subject_question_replies(my_subject_question_replies)
    my_favorite_subject_question_replies_count = FavoriteSubjectQuestionReply.joins(:subject_question_reply).where(subject_question_reply: { user_id: user.id }).count

    my_surveys = user.surveys.with_attached_image.includes(user: { image_attachment: :blob }).select("surveys.*, (SELECT COUNT(*) FROM survey_answers WHERE survey_answers.survey_id = surveys.id) AS survey_answers_count, (SELECT COUNT(*) FROM favorite_surveys WHERE favorite_surveys.survey_id = surveys.id) AS favorite_surveys_count")
    my_surveys_with_images = attach_image_to_surveys(my_surveys)
    my_favorite_surveys_count = FavoriteSurvey.joins(:survey).where(survey: { user_id: user.id }).count

    render json: {
      user: user_json,
      my_reviews: my_reviews_with_images,
      my_questions: my_questions_with_images,
      my_replies: my_replies_with_images,
      my_subject_questions: my_subject_questions_with_images,
      my_subject_question_replies: my_subject_question_replies_with_images,
      my_surveys: my_surveys_with_images,
      my_favorite_reviews_count: my_favorite_reviews_count,
      my_favorite_questions_count: my_favorite_questions_count,
      my_favorite_replies_count: my_favorite_replies_count,
      my_favorite_subject_questions_count: my_favorite_subject_questions_count,
      my_favorite_subject_question_replies_count: my_favorite_subject_question_replies_count,
      my_favorite_surveys_count: my_favorite_surveys_count
    }
  end

  def show_other_user
    user = User.with_attached_image.find_by(id: params[:id])
    return head :not_found unless user

    if user.image.attached?
      image_url = rails_blob_url(user.image)
    end
    user_json = user.as_json.merge(image: image_url)

    my_reviews = user.reviews.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob }).select("reviews.*, (SELECT COUNT(*) FROM favorite_reviews WHERE favorite_reviews.review_id = reviews.id) AS favorite_reviews_count")
    my_reviews_with_images = attach_image_to_reviews(my_reviews)
    my_favorite_reviews_count = FavoriteReview.joins(:review).where(review: { user_id: user.id }).count

    my_questions = user.questions.with_attached_image.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob }).select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
    my_questions_with_images = attach_image_to_questions(my_questions)
    my_favorite_questions_count = FavoriteQuestion.joins(:question).where(questions: { user_id: user.id }).count

    my_replies = user.replies.with_attached_image.includes(:question, user: { image_attachment: :blob }).select("replies.*, (SELECT COUNT(*) FROM favorite_replies WHERE favorite_replies.reply_id = replies.id) AS favorite_replies_count")
    my_replies_with_images = attach_image_to_replies(my_replies)
    my_favorite_replies_count = FavoriteReply.joins(:reply).where(reply: { user_id: user.id }).count

    my_subject_questions = user.subject_questions.with_attached_image.includes(user: { image_attachment: :blob }).select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
    my_subject_questions_with_images = attach_image_to_subject_questions(my_subject_questions)
    my_favorite_subject_questions_count = FavoriteSubjectQuestion.joins(:subject_question).where(subject_question: { user_id: user.id }).count

    my_subject_question_replies = user.subject_question_replies.with_attached_image.includes(:subject_question, user: { image_attachment: :blob }).select("subject_question_replies.*, (SELECT COUNT(*) FROM favorite_subject_question_replies WHERE favorite_subject_question_replies.subject_question_reply_id = subject_question_replies.id) AS favorite_subject_question_replies_count")
    my_subject_question_replies_with_images = attach_image_to_subject_question_replies(my_subject_question_replies)
    my_favorite_subject_question_replies_count = FavoriteSubjectQuestionReply.joins(:subject_question_reply).where(subject_question_reply: { user_id: user.id }).count

    my_surveys = user.surveys.with_attached_image.includes(user: { image_attachment: :blob }).select("surveys.*, (SELECT COUNT(*) FROM survey_answers WHERE survey_answers.survey_id = surveys.id) AS survey_answers_count, (SELECT COUNT(*) FROM favorite_surveys WHERE favorite_surveys.survey_id = surveys.id) AS favorite_surveys_count")
    my_surveys_with_images = attach_image_to_surveys(my_surveys)
    my_favorite_surveys_count = FavoriteSurvey.joins(:survey).where(survey: { user_id: user.id }).count

    render json: {
      user: user_json,
      my_reviews: my_reviews_with_images,
      my_questions: my_questions_with_images,
      my_replies: my_replies_with_images,
      my_subject_questions: my_subject_questions_with_images,
      my_subject_question_replies: my_subject_question_replies_with_images,
      my_surveys: my_surveys_with_images,
      my_favorite_reviews_count: my_favorite_reviews_count,
      my_favorite_questions_count: my_favorite_questions_count,
      my_favorite_replies_count: my_favorite_replies_count,
      my_favorite_subject_questions_count: my_favorite_subject_questions_count,
      my_favorite_subject_question_replies_count: my_favorite_subject_question_replies_count,
      my_favorite_surveys_count: my_favorite_surveys_count
    }
  end

  def check_email_verification_number
    user = User.find_by(email: params[:email])
    user_email_verification_number = params[:email_verification_number]
    user_email_verification_number = user.email_verification_number
    if email_verification_number = user_email_verification_number
      user.activated = true
      user.save
      if Rails.env.development?
        redirect_to "http://localhost:8080/auth/succeededSignUp?email=#{user.email}"
      elsif Rails.env.production?
        redirect_to "http://localhost:8080?email=#{user.email}"
      end
    end
  end

  def check_email_existence
    user = User.find_by(email: params[:email])
    return head :ok unless user

    status = user.activated ? "activated" : "unactivated"
    if status == "activated"
      render json: { existence: true , status: status }
    else
      # アカウントの有効化が完了してない場合は、再度メールを送信する
      email_verification_number = user.email_verification_number
      UserMailer.registration_email(user, email_verification_number).deliver_now
      render json: { existence: true , status: status }
    end
  end

  def create
    user = User.new(user_params)
    email_verification_number = rand(10**7...10**8)
    user.email_verification_number = email_verification_number

    if user.save
      UserMailer.registration_email(user, email_verification_number).deliver_now

      s3_object = Aws::S3::Resource.new.bucket('study-share-image').object('default_user_image.png')

      temp_file = Tempfile.new('downloaded_image', binmode: true)
      temp_file.write(s3_object.get.body.read)
      temp_file.rewind

      user.image.attach(io: temp_file, filename: 'default_image.jpg', content_type: 'image/jpeg')
      temp_file.close
      temp_file.unlink

      render json: user, status: 200
    else
      render json: { error: user.errors.full_messages }, status: 422
    end
  end

  def update
    user = User.find_by(id: params[:id])
    return head :not_found unless user

    return render json: { error: "ゲストユーザーは編集できません" }, status: 422 if user.admin == true

    if user.update(user_params)
      image_url = user.image.attached? ? rails_blob_url(user.image) : nil
      render json: { user: user, image_url: image_url }, status: 200
    else
      render json: { error: user.errors.full_messages }, status: 422
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    return head :not_found unless user

    return render json: { error: "このユーザーは削除できません" }, status: 422 if user.admin == true

    if user.destroy
      head :no_content
    else
      render json: { error: user.errors.full_messages }, status: 422
    end
  end

  def save_user_memo
    current_user = User.find_by(id: params[:current_user_id])
    return render json: { error: "ユーザーが見つかりません" }, status: 404 unless current_user

    memo = params[:memo]
    if current_user.update(memo: memo)
      render json: current_user, status: 200
    else
      render json: { error: current_user.errors.full_messages }, status: 422
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
    return head :not_found unless user

    if user.image.attached?
      image_url = rails_blob_url(user.image)
    end
    user_json = user.as_json.merge(image: image_url)

    render json: user_json
  end

  def find_user_by_email
    user = User.find_by(email: params[:email])
    return head :not_found unless user

    if user.image.attached?
      image_url = rails_blob_url(user.image)
    end
    user_json = user.as_json.merge(image: image_url)

    render json: user_json
  end

  def check_is_activated
    user = User.find_by(email: params[:email])
    return head :not_found unless user

    status = user.activated ? "activated" : "unactivated"
    render json: { status: status }
  end

  def return_cypress_user
    user = User.find_by(name: "cypress-sample")
    return head :not_found unless user

    render json: user
  end



  private

    def user_params
      params.require(:user).permit(:name, :email, :uid, :introduction, :first_choice_school, :second_choice_school, :third_choice_school, :memo, :image)
    end

    def check_admin?(user)
      user.admin == true
    end
end
