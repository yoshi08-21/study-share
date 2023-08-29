require 'rails_helper'

RSpec.describe "Reviews", type: :request do

  let(:user) { create(:user) }
  let(:book) { create(:book, user_id: user.id) }
  let(:review) { create(:review, user_id: user.id, book_id: book.id) }

  describe "レビューの一覧表示" do

    context "参考書に3件のレビューが投稿されていると" do
      it "3件のレビューが表示される" do
        user = create(:user, name: "レビュー投稿者")
        create(:review, title: "英語のレビュー", content: "英語のレビュー本文", user_id: user.id, book_id: book.id)
        create(:review, book_id: book.id)
        create(:review, book_id: book.id)

        get book_reviews_path(book), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(3)
          expect(json_response[0]["title"]).to eq("英語のレビュー")
          expect(json_response[0]["content"]).to eq("英語のレビュー本文")
          expect(json_response[0]["user"]["name"]).to eq("レビュー投稿者")
        end
      end
    end

    context "レビューにいいねがされていると" do
      it "いいねの件数が表示される" do
        user2 = create(:user)
        create(:favorite_review, user_id: user.id, review_id: review.id)
        create(:favorite_review, user_id: user2.id, review_id: review.id)

        get book_reviews_path(book), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)[0]["favorite_reviews_count"]).to eq(2)
      end
    end

    context "参考書にレビューが投稿されていないと" do
      it "空の配列が返ってくる" do
        get book_reviews_path(book), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "参考書が存在しないと" do
      it "レビューの表示に失敗する" do
        get book_reviews_path(-1), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "レビューの詳細表示" do

    context "存在するレビューの詳細ページに遷移すると" do
      it "レビューの詳細情報が表示される" do
        user = create(:user, name: "レビュー投稿者")
        book = create(:book, name: "日本史の教科書", user_id: user.id)
        review = create(:review, title: "テストタイトル", content: "テスト本文", rating: 5, user_id: user.id, book_id: book.id)

        get book_review_path(book, review)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["review"]["title"]).to eq("テストタイトル")
          expect(json_response["review"]["content"]).to eq("テスト本文")
          expect(json_response["review"]["rating"]).to eq(5)
          expect(json_response["review_user"]["name"]).to eq("レビュー投稿者")
        end
      end
      it "レビューに関連する参考書の情報が表示される" do
        user = create(:user)
        book = create(:book, name: "日本史の教科書", author: "日本史太郎", publisher: "日本出版", subject: "日本史", user_id: user.id)
        review = create(:review, title: "テストタイトル1", content: "テスト本文1", rating: 5, user_id: user.id, book_id: book.id)
        review2 = create(:review, title: "テストタイトル2", content: "テスト本文2", rating: 1, user_id: user.id, book_id: book.id)
        question = create(:question, user_id: user.id, book_id: book.id)
        favorite_book = create(:favorite_book, user_id: user.id, book_id: book.id)

        get book_review_path(book, review)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["book"]["name"]).to eq("日本史の教科書")
          expect(json_response["book"]["author"]).to eq("日本史太郎")
          expect(json_response["book"]["publisher"]).to eq("日本出版")
          expect(json_response["book"]["subject"]).to eq("日本史")
          expect(json_response["book"]["reviews_count"]).to eq(2)
          expect(json_response["book"]["average_rating"]).to eq("3.0")
          expect(json_response["book"]["favorite_books_count"]).to eq(1)
          expect(json_response["book"]["questions_count"]).to eq(1)
        end
      end
    end

    context "レビューにいいねがされていると" do
      it "いいねの件数が表示される" do
        user2 = create(:user)
        create(:favorite_review, user_id: user.id, review_id: review.id)
        create(:favorite_review, user_id: user2.id, review_id: review.id)

        get book_reviews_path(book), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)[0]["favorite_reviews_count"]).to eq(2)
      end
    end

    context "レビューが存在しないと" do
      it "レビューの表示に失敗する" do
        review = create(:review, title: "テストタイトル", content: "テスト本文", rating: 5, user_id: user.id, book_id: book.id)

        get book_review_path(book, -1)
        expect(response).to have_http_status(404)
      end
    end

    context "参考書が存在しないと" do
      it "レビューの表示に失敗する" do
        get book_review_path(-1, review), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "レビューの新規投稿" do

    context "正しいパラメーターでレビューを投稿すると" do
      it "レビューの投稿に成功する" do
        expect {
          post book_reviews_path(book), params: {
            review: {
              rating: 5,
              title: "テストタイトル",
              content: "テスト本文",
            },
            current_user_id: user.id
          }
        }.to change(Review, :count).by(1)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["rating"]).to eq(5)
          expect(json_response["title"]).to eq("テストタイトル")
          expect(json_response["content"]).to eq("テスト本文")
        end
      end
    end

    context "不正なパラメーターでレビューを投稿すると" do
      it "レビューの投稿に失敗する" do
        expect {
          post book_reviews_path(book), params: {
            review: {
              rating: "",
              title: "",
              content: "",
            },
            current_user_id: user.id
          }
        }.to change(Review, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "レビューの投稿に失敗する" do
        expect {
          post book_reviews_path(book), params: {
            review: {
              rating: 5,
              title: "テストタイトル",
              content: "テスト本文",
            },
            current_user_id: -1
          }
        }.to change(Review, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

    context "参考書が存在しないと" do
      it "レビューの投稿に失敗する" do
        expect {
          post book_reviews_path(-1), params: {
            review: {
              rating: 5,
              title: "テストタイトル",
              content: "テスト本文",
            },
            current_user_id: user.id
          }
        }.to change(Review, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "レビューの編集" do

    context "正しいパラメーターでレビューを編集すると" do
      it "レビューの編集に成功する" do
        review = create(:review, rating: 5, title: "テストタイトル", content: "テスト本文", user_id: user.id, book_id: book.id)
        aggregate_failures do
          expect(review.rating).to eq(5)
          expect(review.title).to eq("テストタイトル")
          expect(review.content).to eq("テスト本文")
        end

        patch book_review_path(book, review), params: {
          review: {
            rating: "1",
            title: "変更後テストタイトル",
            content: "変更後テスト本文",
          },
          current_user_id: user.id,
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["rating"]).to eq(1)
          expect(json_response["title"]).to eq("変更後テストタイトル")
          expect(json_response["content"]).to eq("変更後テスト本文")
        end
      end
    end

    context "不正なパラメーターでレビューを編集すると" do
      it "レビューの編集に失敗する" do
        review = create(:review, rating: 5, title: "テストタイトル", content: "テスト本文", user_id: user.id, book_id: book.id)

        patch book_review_path(book, review), params: {
          review: {
            rating: "6",
            title: "",
            content: "",
          },
          current_user_id: user.id,
        }
        expect(response).to have_http_status(422)
      end
    end

    context "他人が投稿したレビューを編集すると" do
      it "レビューの編集に失敗する" do
        review = create(:review, rating: 5, title: "テストタイトル", content: "テスト本文", user_id: user.id, book_id: book.id)
        user2 = create(:user)

        patch book_review_path(book, review), params: {
          review: {
            rating: "6",
            title: "",
            content: "",
          },
          current_user_id: user2.id,
        }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "レビューの編集に失敗する" do
        patch book_review_path(book, review), params: {
          review: {
            rating: 5,
            title: "テストタイトル",
            content: "テスト本文",
          },
          current_user_id: -1,
        }
        expect(response).to have_http_status(404)
      end
    end

    context "レビューが存在しないと" do
      it "レビューの編集に失敗する" do
        patch book_review_path(book, -1), params: {
          review: {
            rating: 5,
            title: "テストタイトル",
            content: "テスト本文",
          },
          current_user_id: user.id,
        }
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "レビューの削除" do

    context "自分が作成したレビューを削除すると" do
      it "レビューの削除に成功する" do
        review
        expect {
          delete book_review_path(book, review), params: {
            current_user_id: user.id
          }
        }.to change(Review, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

    context "他人が作成したレビューを削除すると" do
      it "レビューの削除に失敗する" do
        user2 = create(:user)
        review = create(:review, user_id: user.id, book_id: book.id)
        expect {
          delete book_review_path(book, review), params: {
            current_user_id: user2.id
          }
        }.to change(Review, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "レビューの削除に失敗する" do
        user = create(:user)
        book = create(:book, user_id: user.id)
        review = create(:review, user_id: user.id, book_id: book.id)
        expect {
          delete book_review_path(book, review), params: {
            current_user_id: -1
          }
        }.to change(Review, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

    context "レビューが存在しないと" do
      it "レビューの削除に失敗する" do
        user = create(:user)
        book = create(:book, user_id: user.id)
        review = create(:review, user_id: user.id, book_id: book.id)
        expect {
          delete book_review_path(book, -1), params: {
            current_user_id: user.id
          }
        }.to change(Review, :count).by(0)
      end
    end

  end

  describe "レビュー情報の取得" do

    context "check_existenceで存在するレビューをチェックすると" do
      it "成功する" do
        review = create(:review, user_id: user.id, book_id: book.id)
        get check_existence_reviews_path, params: {
          book_id: book.id,
          id: review.id
        }
        expect(response).to have_http_status(200)
      end
    end

    context "check_existenceで存在しないレビューをチェックすると" do
      it "失敗する" do
        get check_existence_reviews_path, params: {
          book_id: book.id,
          id: -1
        }
        expect(response).to have_http_status(404)
      end
    end

  end


  # いいね機能、閲覧履歴、通知機能





end
