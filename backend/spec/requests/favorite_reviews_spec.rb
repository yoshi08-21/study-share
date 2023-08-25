require 'rails_helper'

RSpec.describe "FavoriteReviews", type: :request do

  let(:user) { create(:user) }
  let(:book) { create(:book, user_id: user.id) }
  let(:review) { create(:review, user_id: user.id, book_id: book.id) }
  let(:favorite_review) { create(:favorite_review, user_id: user.id, review_id: review.id) }

  describe "いいねへの登録" do
    context "ユーザーとレビューが存在し、いいねに成功すると" do
      it "レビューのいいねが成功する" do
        user2 = create(:user)
        review = create(:review, user_id: user2.id)

        expect {
          post review_favorite_reviews_path(review), params: {
            user_id: user.id
          }
        }.to change(FavoriteReview, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいねに失敗する" do
        expect {
          post review_favorite_reviews_path(review), params: {
            user_id: -1
          }
        }.to change(FavoriteReview, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "レビューが存在しないと" do
      it "いいねに失敗する" do
        expect {
          post review_favorite_reviews_path(-1), params: {
            user_id: user.id
          }
        }.to change(FavoriteReview, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "自分のレビューにいいねすると" do
      it "いいねに失敗する" do
        review = create(:review, user_id: user.id, book_id: book.id)

        expect {
          post review_favorite_reviews_path(review), params: {
            user_id: user.id
          }
        }.to change(FavoriteReview, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
    context "ユーザーがすでにレビューにいいねしている場合" do
      it "いいねに失敗する" do
        user2 = create(:user)
        review = create(:review, user_id: user2.id, book_id: book.id)
        favorite_reivew = create(:favorite_review, user_id: user.id, review_id: review.id)

        expect {
          post review_favorite_reviews_path(review), params: {
            user_id: user.id
          }
        }.to change(FavoriteReview, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end
  describe "いいねの削除" do
    context "ユーザーとレビューといいねが存在し、いいねを削除すると" do
      it "いいね削除に成功する" do
        favorite_review = create(:favorite_review, user_id: user.id, review_id: review.id)

        expect {
          delete review_favorite_review_path(review, favorite_review), params: {
            user_id: user.id
          }
        }.to change(FavoriteReview, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいね削除に失敗する" do
        favorite_review = create(:favorite_review, user_id: user.id, review_id: review.id)
        expect {
          delete review_favorite_review_path(review, favorite_review), params: {
            user_id: -1
          }
        }.to change(FavoriteReview, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "レビューが存在しないと" do
      it "いいね削除に失敗する" do
        favorite_review = create(:favorite_review, user_id: user.id, review_id: review.id)
        expect {
          delete review_favorite_review_path(-1, favorite_review), params: {
            user_id: user.id
          }
        }.to change(FavoriteReview, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ユーザーとレビューに紐づくいいねが存在しないと" do
      it "いいね削除に失敗する" do
        user2 = create(:user)
        favorite_review = create(:favorite_review, user_id: user2.id, review_id: review.id)
        expect {
          delete review_favorite_review_path(review, favorite_review), params: {
            user_id: user.id
          }
        }.to change(FavoriteReview, :count).by(0)
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)["error"]).to eq("いいねされていません")
      end
    end
  end




end
