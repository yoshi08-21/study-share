require 'rails_helper'

RSpec.describe "FavoriteBooks", type: :request do

  let(:user) { create(:user) }
  let(:book) { create(:book, user_id: user.id) }
  let(:favorite_book) { create(:favorite_book, user_id: user.id, book_id: book.id) }

  describe "お気に入りへの登録" do
    context "ユーザーと参考書が存在し、お気に入り登録に成功すると" do
      it "参考書がお気に入りに登録される" do
        expect {
          post book_favorite_books_path(book), params: {
            user_id: user.id
          }
        }.to change(FavoriteBook, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end
    context "ユーザーが参考書をすでにお気に入りに登録している場合" do
      it "お気に入り登録に失敗する" do
        create(:favorite_book, user_id: user.id, book_id: book.id)
        expect {
          post book_favorite_books_path(book), params: {
            user_id: user.id
          }
        }.to change(FavoriteBook, :count).by(0)
        puts response.body
        expect(response).to have_http_status(422)
      end
    end
    context "参考書が存在しないと" do
      it "お気に入り登録に失敗する" do
        expect {
          post book_favorite_books_path(-1), params: {
            user_id: user.id
          }
        }.to change(FavoriteBook, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "お気に入り登録に失敗する" do
        expect {
          post book_favorite_books_path(book), params: {
            user_id: -1
          }
        }.to change(FavoriteBook, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "お気に入りの削除" do
    context "ユーザーと参考書とお気に入りが存在し、お気に入りを削除すると" do
      it "お気に入り削除に成功する" do
        favorite_book = create(:favorite_book, user_id: user.id, book_id: book.id)
        expect {
          delete book_favorite_book_path(book, favorite_book), params: {
            user_id: user.id
          }
        }.to change(FavoriteBook, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "参考書が存在しないと" do
      it "お気に入り削除に失敗する" do
        favorite_book = create(:favorite_book, user_id: user.id, book_id: book.id)
        expect {
          delete book_favorite_book_path(-1, favorite_book), params: {
            user_id: user.id
          }
        }.to change(FavoriteBook, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "お気に入り削除に失敗する" do
        favorite_book = create(:favorite_book, user_id: user.id, book_id: book.id)
        expect {
          delete book_favorite_book_path(book, favorite_book), params: {
            user_id: -1
          }
        }.to change(FavoriteBook, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ユーザーと参考書に紐づくお気に入りが存在しないと" do
      it "お気に入り削除に失敗する" do
        user2 = create(:user)
        favorite_book = create(:favorite_book, user_id: user2.id, book_id: book.id)
        expect {
          delete book_favorite_book_path(book, favorite_book), params: {
            user_id: user.id
          }
        }.to change(FavoriteBook, :count).by(0)
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)["error"]).to eq("お気に入りに登録されていません")
      end
    end
  end
  describe "一覧表示でのお気に入りの削除(destroy_from_item_list)" do
    context "ユーザーと参考書とお気に入りが存在し、お気に入りを削除すると" do
      it "お気に入り削除に成功する" do
        favorite_book = create(:favorite_book, user_id: user.id, book_id: book.id)
        expect {
          delete favorite_books_destroy_from_item_list_path, params: {
            user_id: user.id,
            book_id: book.id
          }
        }.to change(FavoriteBook, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "参考書が存在しないと" do
      it "お気に入り削除に失敗する" do
        favorite_book = create(:favorite_book, user_id: user.id, book_id: book.id)
        expect {
          delete favorite_books_destroy_from_item_list_path, params: {
            user_id: user.id,
            book_id: -1
          }
        }.to change(FavoriteBook, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "お気に入り削除に失敗する" do
        favorite_book = create(:favorite_book, user_id: user.id, book_id: book.id)
        expect {
          delete favorite_books_destroy_from_item_list_path, params: {
            user_id: -1,
            book_id: book.id
          }
        }.to change(FavoriteBook, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ユーザーと参考書に紐づくお気に入りが存在しないと" do
      it "お気に入り削除に失敗する" do
        user2 = create(:user)
        favorite_book = create(:favorite_book, user_id: user2.id, book_id: book.id)
        expect {
          delete favorite_books_destroy_from_item_list_path, params: {
            user_id: user.id,
            book_id: book.id
          }
        }.to change(FavoriteBook, :count).by(0)
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)["error"]).to eq("お気に入りに登録されていません")
      end
    end
  end



end
