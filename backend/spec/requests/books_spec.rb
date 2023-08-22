require 'rails_helper'

RSpec.describe "Books", type: :request do

  let(:user) { create(:user) }
  let(:book) { create(:book, user_id: user.id) }

  describe "参考書の一覧表示" do
    context "3冊の参考書が登録されている状態で参考書一覧ページに遷移すると" do
      it "3冊の参考書が表示される" do
        user
        create(:book, name: "参考書1", user_id: user.id)
        create(:book, name: "参考書2", user_id: user.id)
        create(:book, name: "参考書3", user_id: user.id)

        get books_path, params: {
          current_user_id: 1
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response[0]["name"]).to eq("参考書1")
          expect(json_response[0]["image"]).to include("no_image.png")
          expect(json_response[1]["name"]).to eq("参考書2")
          expect(json_response[2]["name"]).to eq("参考書3")
        end
      end
    end
  end
  describe "参考書の詳細表示" do
    context "存在する参考書の詳細ページに遷移すると" do
      it "参考書の詳細情報が取得できる" do
        user
        book = create(:book, name: "参考書1", user_id: user.id)
        get book_path(book)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["name"]).to eq("参考書1")
          expect(json_response["author"]).to eq("東京太郎")
          expect(json_response["publisher"]).to eq("東京出版")
        end
      end
    end
    context "存在しない参考書の詳細ページに遷移すると" do
      it "参考書の取得に失敗する" do
        get book_path(-1)
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "参考書情報の取得" do
    context "check_existenceで存在する参考書をチェックすると" do
      it "成功する" do
        user
        book = create(:book, name: "参考書1", user_id: user.id)
        get check_existence_books_path, params: {
          id: book.id
        }
        expect(response).to have_http_status(200)
      end
    end
    context "check_existenceで存在する参考書をチェックすると" do
      it "失敗する" do
        user
        create(:book, name: "参考書1", user_id: user.id)
        get check_existence_books_path, params: {
          id: -1
        }
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "参考書の新規登録" do
    context "正しいパラメーターで参考書を登録すると" do
      it "参考書の登録に成功する" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')

        expect {
          post books_path, params: {
            book: {
              name: "参考書1",
              author: "東京太郎",
              publisher: "東京出版",
              subject: "国語",
              description: "国語の参考書",
              image: image,
              user_id: user.id
            }
          }
        }.to change(Book, :count).by(1)

        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["name"]).to eq("参考書1")
          expect(json_response["author"]).to eq("東京太郎")
          expect(json_response["publisher"]).to eq("東京出版")
          expect(json_response["subject"]).to eq("国語")
          expect(json_response["description"]).to eq("国語の参考書")
          expect(json_response["user_id"]).to eq(user.id)
        end

        get book_path(json_response["id"])
        expect(response).to have_http_status(200)

        json_book_response = JSON.parse(response.body)
        expect(json_book_response["image"]).to include("no_image.png")
      end
    end
    context "参考書の登録時に画像が未選択の場合" do
      it "デフォルトの画像が添付される" do
        expect {
          post books_path, params: {
            book: {
              name: "参考書1",
              author: "東京太郎",
              publisher: "東京出版",
              subject: "国語",
              description: "国語の参考書",
              user_id: user.id
            }
          }
        }.to change(Book, :count).by(1)

        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        get book_path(json_response["id"])
        expect(response).to have_http_status(200)

        json_book_response = JSON.parse(response.body)
        expect(json_book_response["image"]).to include("default_image.jpg")
      end
    end
    context "不正なパラメーターで参考書を登録すると" do
      it "参考書の登録に失敗する" do
        expect {
          post books_path, params: {
            book: {
              name: "",
              author: "",
              subject: "",
              user_id: user.id
            }
          }
        }.to change(Book, :count).by(0)
        expect(response).to have_http_status(400)
      end
    end
  end
  describe "参考書の編集" do
    context "正しいパラメーターで参考書を編集すると" do
      it "参考書の編集に成功する" do
        book = create(:book, name: "参考書1", author: "東京太郎", user_id: user.id)
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')

        aggregate_failures do
          expect(book.name).to eq("参考書1")
          expect(book.author).to eq("東京太郎")
          expect(book.publisher).to eq("東京出版")
          expect(book.subject).to eq("その他")
          expect(book.description).to eq(nil)
        end
        patch book_path(book), params: {
          book: {
            name: "参考書2",
            author: "神奈川一郎",
            publisher: "神奈川書房",
            subject: "英語",
            description: "英語の参考書",
            image: image,
            user_id: user.id
          }
        }
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        aggregate_failures do
          expect(json_response["book"]["name"]).to eq("参考書2")
          expect(json_response["book"]["author"]).to eq("神奈川一郎")
          expect(json_response["book"]["publisher"]).to eq("神奈川書房")
          expect(json_response["book"]["subject"]).to eq("英語")
          expect(json_response["book"]["description"]).to eq("英語の参考書")
          expect(json_response["image_url"]).to include("no_image.png")
        end
      end
    end
    context "不正なパラメーターで参考書を編集すると" do
      it "参考書の編集に失敗する" do
        book = create(:book, name: "参考書1", author: "東京太郎", user_id: user.id)

        patch book_path(book), params: {
          book: {
            name: "",
            author: "",
            subject: "",
            user_id: user.id
          }
        }
        expect(response).to have_http_status(400)
      end
    end
    context "他人が作成した参考書を編集すると" do
      it "参考書の編集に失敗する" do
        user2 = create(:user, name: "東京二郎")
        book = create(:book, name: "参考書1", author: "東京太郎", user_id: user.id)

        patch book_path(book), params: {
          book: {
            name: "参考書2",
            author: "神奈川一郎",
            publisher: "神奈川書房",
            subject: "英語",
            user_id: user2.id
          }
        }
        expect(response).to have_http_status(400)

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("権限がありません")
      end
    end
  end
  describe "参考書の削除" do
    context "自分が作成した参考書を削除すると" do
      it "参考書の削除に成功する" do
        book = create(:book, user_id: user.id)
        expect {
          delete book_path(book), params: {
            current_user_id: user.id
          }
        }.to change(Book, :count).by(-1)

        expect(response).to have_http_status(204)
      end
    end
    context "他人が作成した参考書を削除すると" do
      it "参考書の削除に失敗する" do
        book = create(:book, user_id: user.id)
        user2 = create(:user)
        expect {
          delete book_path(book), params: {
            current_user_id: user2.id
          }
        }.to change(Book, :count).by(0)

        expect(response).to have_http_status(400)
      end
    end
  end
  describe "参考書の検索" do
    context "登録されている参考書をタイトルで検索すると" do
      it "参考書が表示される" do
        create(:book, name: "参考書1", author: "東京太郎", publisher: "東京出版", user_id: user.id)
        get search_books_books_path, params: {
          current_user_id: user.id,
          searchBooksKeyword: "参考書1"
        }
        expect(response).to have_http_status(200)

        first_json_response = JSON.parse(response.body)
        expect(first_json_response["books"][0]["name"]).to eq("参考書1")

        get search_books_books_path, params: {
          current_user_id: user.id,
          searchBooksKeyword: "参考"
        }
        expect(response).to have_http_status(200)

        second_json_response = JSON.parse(response.body)
        expect(second_json_response["books"][0]["name"]).to eq("参考書1")
      end
    end
    context "登録されている参考書を著者名で検索すると" do
      it "参考書が表示される" do
        create(:book, name: "参考書1", author: "東京太郎", publisher: "東京出版", user_id: user.id)
        get search_books_books_path, params: {
          current_user_id: user.id,
          searchBooksKeyword: "東京太郎"
        }
        expect(response).to have_http_status(200)

        first_json_response = JSON.parse(response.body)
        expect(first_json_response["books"][0]["name"]).to eq("参考書1")

        get search_books_books_path, params: {
          current_user_id: user.id,
          searchBooksKeyword: "太郎"
        }
        expect(response).to have_http_status(200)

        second_json_response = JSON.parse(response.body)
        expect(second_json_response["books"][0]["name"]).to eq("参考書1")
      end
    end
    context "登録されている参考書を出版社名で検索すると" do
      it "参考書が表示される" do
        create(:book, name: "参考書1", author: "東京太郎", publisher: "東京出版", user_id: user.id)
        get search_books_books_path, params: {
          current_user_id: user.id,
          searchBooksKeyword: "東京出版"
        }
        expect(response).to have_http_status(200)

        first_json_response = JSON.parse(response.body)
        expect(first_json_response["books"][0]["name"]).to eq("参考書1")

        get search_books_books_path, params: {
          current_user_id: user.id,
          searchBooksKeyword: "出版"
        }
        expect(response).to have_http_status(200)

        second_json_response = JSON.parse(response.body)
        expect(second_json_response["books"][0]["name"]).to eq("参考書1")
      end
    end
    context "登録されていない参考書を検索すると" do
      it "参考書が表示されない" do
        create(:book, name: "参考書1", author: "東京太郎", publisher: "東京出版", user_id: user.id)
        get search_books_books_path, params: {
          current_user_id: user.id,
          searchBooksKeyword: "教科書"
        }
        expect(response).to have_http_status(404)

        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("検索結果がありません")
      end
    end
    context "check_existenceで存在する参考書をチェックすると" do
      it "成功する" do
        get check_existence_books_path, params: {
          id: book.id
        }
        expect(response).to have_http_status(200)
      end
    end
    context "check_existenceで存在しない参考書をチェックすると" do
      it "失敗する" do
        get check_existence_books_path, params: {
          id: -1
        }
        expect(response).to have_http_status(404)
      end
    end


  end









end
