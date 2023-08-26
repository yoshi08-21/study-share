class SubjectQuestionRepliesController < ApplicationController

  include SharedActions::AttachImage
  include SharedActions::DateTime


  def index
    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    return head :not_found unless subject_question

    subject_question_replies = SubjectQuestionReply.with_attached_image
                                                    .includes(user: { image_attachment: :blob }, subject_question: { image_attachment: :blob })
                                                    .select("subject_question_replies.*, (SELECT COUNT(*) FROM favorite_subject_question_replies WHERE favorite_subject_question_replies.subject_question_reply_id = subject_question_replies.id) AS favorite_subject_question_replies_count")
                                                    .where(subject_question_id: subject_question.id)
    return render json: [] if subject_question_replies.blank?

    subject_question_replies_with_images = attach_image_to_subject_question_replies(subject_question_replies)
    render json: subject_question_replies_with_images
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])
    subject_question = SubjectQuestion.includes(user: { image_attachment: :blob })
                                      .select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
                                      .find_by(id: params[:subject_question_id])
    return head :not_found unless subject_question
    subject_question_user = subject_question.user
    subject_question_user_json = attach_image_to_user(subject_question_user)

    subject_question_reply = SubjectQuestionReply.with_attached_image
                                                  .includes(user: { image_attachment: :blob })
                                                  .select("subject_question_replies.*, (SELECT COUNT(*) FROM favorite_subject_question_replies WHERE favorite_subject_question_replies.subject_question_reply_id = subject_question_replies.id) AS favorite_subject_question_replies_count")
                                                  .find_by(id: params[:id])
    return head :not_found unless subject_question_reply
    subject_question_reply_json = attach_image_to_reply(subject_question_reply)
    subject_question_reply_json["created_at"] = format_japanese_time(subject_question_reply.created_at)

    subject_question_reply_user = subject_question_reply.user
    subject_question_reply_user_json = attach_image_to_user(subject_question_reply_user)

    if current_user && !exist_subject_question_reply_browsing_history?(current_user, subject_question_reply)
      save_subject_question_reply_browsing_history(current_user, subject_question_reply)
    end
    render json: {
      subject_question: subject_question,
      subject_question_user: subject_question_user_json,
      subject_question_reply: subject_question_reply_json,
      subject_question_reply_user: subject_question_reply_user_json
    }
  end

  def create
    current_user = User.find_by(id: params[:subject_question_reply][:user_id])
    subject_question = SubjectQuestion.includes(:user).find_by(id: params[:subject_question_id])
    subject_question_reply = current_user.subject_question_replies.build(subject_question_reply_params)
    subject_question_reply.subject_question_id = subject_question.id
    if subject_question_reply.save
      create_notification_subject_question_reply(current_user, subject_question.user, subject_question, subject_question_reply)
      render json: subject_question_reply, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def update
    current_user = User.find_by(id: params[:subject_question_reply][:user_id])
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:id])
    author = subject_question_reply.user
    if validate_authorship(current_user, author)
      if subject_question_reply.update(subject_question_reply_params)
        image_url = subject_question_reply.image.attached? ? rails_blob_url(subject_question_reply.image) : nil
        render json: { subject_question_reply: subject_question_reply, image_url: image_url }, status: 200
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:id])
    author = subject_question_reply.user
    if validate_authorship(current_user, author)
      if subject_question_reply.destroy
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
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:subject_question_reply_id])
    favorite_subject_question_reply = FavoriteSubjectQuestionReply.find_by(user_id: current_user.id, subject_question_reply_id: subject_question_reply.id) if current_user
    if favorite_subject_question_reply
      render json: { is_favorite: true, favorite_subject_question_reply_id: favorite_subject_question_reply.id }
    else
      render json: false
    end
  end

  def create_sample_notification
    current_user = User.find_by(id: params[:current_user_id])
    sample_user = User.find_by(id: params[:sample_user_id])
    current_user_question = current_user.subject_questions.first
    if current_user_question.nil?
      current_user_question = current_user.subject_questions.create(
        title: "通知確認用サンプル質問",
        content: "通知確認用サンプル質問",
        subject: "国語"
      )
    end
    sample_user_new_reply = sample_user.subject_question_replies.create(
      content: "通知確認用サンプル返信",
      subject_question_id: current_user_question.id
    )
    create_notification_subject_question_reply(sample_user, current_user, current_user_question, sample_user_new_reply)
    if sample_user_new_reply
      render json: sample_user_new_reply
    else
      render json: sample_user_new_reply.errors
    end
  end

  # checkResourceExistence.jsから呼び出し
  def check_existence
    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:id])
    if subject_question && subject_question_reply
      head :ok
    else
      head :not_found
    end
  end



  private

    def subject_question_reply_params
      params.require(:subject_question_reply).permit(:content, :user_id, :subject_question_id, :image)
    end

    def exist_subject_question_reply_browsing_history?(current_user, subject_question_reply)
      current_user.watched_subject_question_replies.include?(subject_question_reply)
    end

    def save_subject_question_reply_browsing_history(current_user, subject_question_reply)
      subject_question_reply_browsing_histories = BrowsingHistory.where(user_id: current_user.id).where.not(subject_question_reply_id: nil)
      max_browsing_histories = 10
      if subject_question_reply_browsing_histories.count >= max_browsing_histories
        subject_question_reply_browsing_histories.first.destroy
        current_user.browsing_histories.create(subject_question_reply_id: subject_question_reply.id)
      else
        current_user.browsing_histories.create(subject_question_reply_id: subject_question_reply.id)
      end
    end

    def create_notification_subject_question_reply(current_user, subject_question_author, subject_question, subject_question_reply)
      # 質問の投稿者に通知を作成する
      # 自分の質問に自分で返信を投稿したときは通知を作成しない
      if current_user.id != subject_question_author.id
        subject_question_reply_notification = current_user.sent_notifications.build(
          target_user_id: subject_question_author.id,
          subject_question_id: subject_question.id,
          subject_question_reply_id: subject_question_reply.id,
          action_type: "Reply",
          action_to: "SubjectQuestionReply"
        )
        subject_question_reply_notification.save if subject_question_reply_notification.valid?
      end

      # 返信が投稿されたとき、投稿者以外のその質問に返信しているユーザー全員に通知を作成する
      # 自分には通知を作成しない、質問の投稿者にも通知を作成しない（上の処理で質問の投稿者には通知が作成されるため、２重になってしまう）
      replied_users_id = SubjectQuestionReply.select(:user_id).where(subject_question_id: subject_question.id).where.not(user_id: current_user.id).where.not(user_id: subject_question_author.id).distinct
      replied_users_id.each do |replied_user_id|
        notification = current_user.sent_notifications.build(
          target_user_id: replied_user_id.user_id,
          subject_question_id: subject_question.id,
          subject_question_reply_id: subject_question_reply.id,
          action_type: "Reply",
          action_to: "SubjectQuestionReply"
        )
        notification.save if notification.valid?
      end
    end


end
