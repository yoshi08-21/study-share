require 'rails_helper'

RSpec.describe "FavoriteSubjectQuestionReplies", type: :request do

  let(:user) { create(:user) }
  let(:subject_question) { create(:subject_question, user_id: user.id) }
  let(:subject_question_reply) { create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id) }
  let(:favorite_subject_question_reply) { create(:favorite_subject_question_reply, user_id: user.id, subject_question_reply_id: subject_question_reply.id) }

  describe "いいねへの登録" do
    context "ユーザーと返信が存在し、他人の返信へのいいねに成功すると" do
      it "返信のいいねが成功する" do
        user2 = create(:user)
        subject_question_reply = create(:subject_question_reply, user_id: user2.id, subject_question_id: subject_question.id)

        expect {
          post subject_question_reply_favorite_subject_question_replies_path(subject_question_reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteSubjectQuestionReply, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいねに失敗する" do
        expect {
          post subject_question_reply_favorite_subject_question_replies_path(subject_question_reply), params: {
            current_user_id: -1
          }
        }.to change(FavoriteSubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "返信が存在しないと" do
      it "いいねに失敗する" do
        expect {
          post subject_question_reply_favorite_subject_question_replies_path(-1), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteSubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "自分の返信にいいねすると" do
      it "いいねに失敗する" do
        subject_question_reply = create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id)

        expect {
          post subject_question_reply_favorite_subject_question_replies_path(subject_question_reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteSubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("自分の返信にはいいねできません")
      end
    end
    context "ユーザーがすでに返信にいいねしている場合" do
      it "いいねに失敗する" do
        user2 = create(:user)
        subject_question_reply = create(:subject_question_reply, user_id: user2.id, subject_question_id: subject_question.id)
        favorite_subject_question_reply = create(:favorite_subject_question_reply, user_id: user.id, subject_question_reply_id: subject_question_reply.id)

        expect {
          post subject_question_reply_favorite_subject_question_replies_path(subject_question_reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteSubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end
  describe "いいねの削除" do
    context "ユーザーと返信といいねが存在し、いいねを削除すると" do
      it "いいね削除に成功する" do
        favorite_subject_question_reply = create(:favorite_subject_question_reply, user_id: user.id, subject_question_reply_id: subject_question_reply.id)

        expect {
          delete subject_question_reply_favorite_subject_question_reply_path(subject_question_reply, favorite_subject_question_reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteSubjectQuestionReply, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいね削除に失敗する" do
        favorite_subject_question_reply = create(:favorite_subject_question_reply, user_id: user.id, subject_question_reply_id: subject_question_reply.id)
        expect {
          delete subject_question_reply_favorite_subject_question_reply_path(subject_question_reply, favorite_subject_question_reply), params: {
            current_user_id: -1
          }
        }.to change(FavoriteSubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "返信が存在しないと" do
      it "いいね削除に失敗する" do
        favorite_subject_question_reply = create(:favorite_subject_question_reply, user_id: user.id, subject_question_reply_id: subject_question_reply.id)
        expect {
          delete subject_question_reply_favorite_subject_question_reply_path(-1, favorite_subject_question_reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteSubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ユーザーと返信に紐づくいいねが存在しないと" do
      it "いいね削除に失敗する" do
        user2 = create(:user)
        favorite_subject_question_reply = create(:favorite_subject_question_reply, user_id: user2.id, subject_question_reply_id: subject_question_reply.id)
        expect {
          delete subject_question_reply_favorite_subject_question_reply_path(subject_question_reply, favorite_subject_question_reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteSubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)["error"]).to eq("いいねされていません")
      end
    end
  end


end
