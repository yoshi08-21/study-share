require 'rails_helper'

RSpec.describe "FavoriteReplies", type: :request do

  let(:user) { create(:user) }
  let(:book) { create(:book, user_id: user.id) }
  let(:question) { create(:question, user_id: user.id, book_id: book.id) }
  let(:reply) { create(:reply, user_id: user.id, question_id: question.id) }
  let(:favorite_reply) { create(:favorite_reply, user_id: user.id, reply_id: reply.id) }

  describe "いいねへの登録" do
    context "ユーザーと返信が存在し、他人の返信へのいいねに成功すると" do
      it "返信のいいねが成功する" do
        user2 = create(:user)
        reply = create(:reply, user_id: user2.id, question_id: question.id)

        expect {
          post reply_favorite_replies_path(reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteReply, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいねに失敗する" do
        expect {
          post reply_favorite_replies_path(reply), params: {
            current_user_id: -1
          }
        }.to change(FavoriteReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "返信が存在しないと" do
      it "いいねに失敗する" do
        expect {
          post reply_favorite_replies_path(-1), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "自分の返信にいいねすると" do
      it "いいねに失敗する" do
        reply = create(:reply, user_id: user.id, question_id: question.id)

        expect {
          post reply_favorite_replies_path(reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteReply, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("自分の返信にはいいねできません")
      end
    end
    context "ユーザーがすでに返信にいいねしている場合" do
      it "いいねに失敗する" do
        user2 = create(:user)
        reply = create(:reply, user_id: user2.id, question_id: question.id)
        favorite_reply = create(:favorite_reply, user_id: user.id, reply_id: reply.id)

        expect {
          post reply_favorite_replies_path(reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteReply, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end
  describe "いいねの削除" do
    context "ユーザーと返信といいねが存在し、いいねを削除すると" do
      it "いいね削除に成功する" do
        favorite_reply = create(:favorite_reply, user_id: user.id, reply_id: reply.id)

        expect {
          delete reply_favorite_reply_path(reply, favorite_reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteReply, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいね削除に失敗する" do
        favorite_reply = create(:favorite_reply, user_id: user.id, reply_id: reply.id)
        expect {
          delete reply_favorite_reply_path(reply, favorite_reply), params: {
            current_user_id: -1
          }
        }.to change(FavoriteReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "返信が存在しないと" do
      it "いいね削除に失敗する" do
        favorite_reply = create(:favorite_reply, user_id: user.id, reply_id: reply.id)
        expect {
          delete reply_favorite_reply_path(-1, favorite_reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ユーザーと返信に紐づくいいねが存在しないと" do
      it "いいね削除に失敗する" do
        user2 = create(:user)
        favorite_reply = create(:favorite_reply, user_id: user2.id, reply_id: reply.id)
        expect {
          delete reply_favorite_reply_path(reply, favorite_reply), params: {
            current_user_id: user.id
          }
        }.to change(FavoriteReply, :count).by(0)
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)["error"]).to eq("いいねされていません")
      end
    end
  end




end
