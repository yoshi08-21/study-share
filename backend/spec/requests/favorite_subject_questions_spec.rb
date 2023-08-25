require 'rails_helper'

RSpec.describe "FavoriteSubjectQuestions", type: :request do

  let(:user) { create(:user) }
  let(:subject_question) { create(:subject_question, user_id: user.id) }
  let(:favorite_subject_question) { create(:favorite_subject_question, user_id: user.id, subject_question_id:subject_question.id) }

  describe "いいねへの登録" do
    context "ユーザーと質問が存在し、他人の質問へのいいねに成功すると" do
      it "質問のいいねが成功する" do
        user2 = create(:user)
        subject_question = create(:subject_question, user_id: user2.id)

        expect {
          post subject_question_favorite_subject_questions_path(subject_question), params: {
            user_id: user.id
          }
        }.to change(FavoriteSubjectQuestion, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいねに失敗する" do
        expect {
          post subject_question_favorite_subject_questions_path(subject_question), params: {
            user_id: -1
          }
        }.to change(FavoriteSubjectQuestion, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "質問が存在しないと" do
      it "いいねに失敗する" do
        expect {
          post subject_question_favorite_subject_questions_path(-1), params: {
            user_id: user.id
          }
        }.to change(FavoriteSubjectQuestion, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "自分の質問にいいねすると" do
      it "いいねに失敗する" do
        subject_question = create(:subject_question, user_id: user.id)

        expect {
          post subject_question_favorite_subject_questions_path(subject_question), params: {
            user_id: user.id
          }
        }.to change(FavoriteSubjectQuestion, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("自分の質問にはいいねできません")
      end
    end
    context "ユーザーがすでに質問にいいねしている場合" do
      it "いいねに失敗する" do
        user2 = create(:user)
        subject_question = create(:subject_question, user_id: user2.id)
        favorite_subject_question = create(:favorite_subject_question, user_id: user.id, subject_question_id: subject_question.id)

        expect {
          post subject_question_favorite_subject_questions_path(subject_question), params: {
            user_id: user.id
          }
        }.to change(FavoriteSubjectQuestion, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end
  describe "いいねの削除" do
    context "ユーザーと質問といいねが存在し、いいねを削除すると" do
      it "いいね削除に成功する" do
        favorite_subject_question = create(:favorite_subject_question, user_id: user.id, subject_question_id: subject_question.id)

        expect {
          delete subject_question_favorite_subject_question_path(subject_question, favorite_subject_question), params: {
            user_id: user.id
          }
        }.to change(FavoriteSubjectQuestion, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいね削除に失敗する" do
        favorite_subject_question = create(:favorite_subject_question, user_id: user.id, subject_question_id: subject_question.id)
        expect {
          delete subject_question_favorite_subject_question_path(subject_question, favorite_subject_question), params: {
            user_id: -1
          }
        }.to change(FavoriteSubjectQuestion, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "質問が存在しないと" do
      it "いいね削除に失敗する" do
        favorite_subject_question = create(:favorite_subject_question, user_id: user.id, subject_question_id: subject_question.id)
        expect {
          delete subject_question_favorite_subject_question_path(-1 ,favorite_subject_question), params: {
            user_id: user.id
          }
        }.to change(FavoriteSubjectQuestion, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ユーザーと質問に紐づくいいねが存在しないと" do
      it "いいね削除に失敗する" do
        user2 = create(:user)
        favorite_subject_question = create(:favorite_subject_question, user_id: user2.id, subject_question_id: subject_question.id)
        expect {
          delete subject_question_favorite_subject_question_path(subject_question, favorite_subject_question), params: {
            user_id: user.id
          }
        }.to change(FavoriteSubjectQuestion, :count).by(0)
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)["error"]).to eq("いいねされていません")
      end
    end
  end




end
