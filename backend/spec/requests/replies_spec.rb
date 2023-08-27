require 'rails_helper'

RSpec.describe "Replies", type: :request do

  let(:user) { create(:user) }
  let(:book) { create(:book, user_id: user.id) }
  let(:question) { create(:question, user_id: user.id, book_id: book.id) }
  let(:reply) { create(:reply, user_id: user.id, question_id: question.id) }

  describe "返信の一覧表示" do

    context "質問に3件の返信が投稿されていると" do
      it "3件の返信が表示される" do
        user = create(:user, name: "返信投稿者")
        create(:reply, content: "テスト返信本文", user_id: user.id, question_id: question.id)
        create(:reply, user_id: user.id, question_id: question.id)
        create(:reply, user_id: user.id, question_id: question.id)

        get book_question_replies_path(book, question)
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(3)
          expect(json_response[0]["content"]).to eq("テスト返信本文")
          expect(json_response[0]["user"]["name"]).to eq("返信投稿者")
        end
      end
    end

    context "返信にいいねがされていると" do
      it "いいねの件数が表示される" do
        user2 = create(:user)
        create(:favorite_reply, user_id: user.id, reply_id: reply.id)
        create(:favorite_reply, user_id: user2.id, reply_id: reply.id)

        get book_question_replies_path(book, question)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)[0]["favorite_replies_count"]).to eq(2)
      end
    end

    context "質問に返信が投稿されていないと" do
      it "空の配列が返ってくる" do
        get book_question_replies_path(book, question)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(0)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "質問が存在しないと" do
      it "返信の表示に失敗する" do
        get book_question_replies_path(book, -1)
        expect(response).to have_http_status(404)
      end
    end


  end

  describe "返信の詳細表示" do

    context "存在する返信の詳細ページに遷移すると" do
      it "返信の詳細情報が取得できる" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')
        user = create(:user, name: "返信投稿者")
        question_user = create(:user, name: "質問投稿者")
        book = create(:book, name: "世界史の教科書", user_id: user.id)
        question = create(:question, title: "テスト質問タイトル", content: "テスト質問本文", user_id: question_user.id, book_id: book.id)
        reply = create(:reply, content: "テスト返信本文", image: image, question_id: question.id, user_id: user.id)

        get book_question_reply_path(book, question, reply)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["reply"]["content"]).to eq("テスト返信本文")
          expect(json_response["reply"]["image"]).to include("no_image.png")
          expect(json_response["reply_user"]["name"]).to eq("返信投稿者")
        end
      end

      it "返信に関連する質問の情報が表示される" do
        user = create(:user, name: "返信投稿者")
        question_user = create(:user, name: "質問投稿者")
        book = create(:book, name: "世界史の教科書", user_id: user.id)
        question = create(:question, title: "テスト質問タイトル", content: "テスト質問本文", user_id: question_user.id, book_id: book.id)
        reply = create(:reply, content: "テスト返信本文", question_id: question.id, user_id: user.id)
        favorite_question = create(:favorite_question, user_id: user.id, question_id: question.id)

        get book_question_reply_path(book, question, reply)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["book"]["name"]).to eq("世界史の教科書")
          expect(json_response["question"]["title"]).to eq("テスト質問タイトル")
          expect(json_response["question"]["content"]).to eq("テスト質問本文")
          expect(json_response["question"]["favorite_questions_count"]).to eq(1)
          expect(json_response["question"]["replies_count"]).to eq(1)
          expect(json_response["question_user"]["name"]).to eq("質問投稿者")
        end
      end

      context "返信にいいねがされていると" do
        it "いいねの件数が表示される" do
          user2 = create(:user)
          create(:favorite_reply, user_id: user.id, reply_id: reply.id)
          create(:favorite_reply, user_id: user2.id, reply_id: reply.id)

          get book_question_reply_path(book, question, reply)
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)["reply"]["favorite_replies_count"]).to eq(2)
        end
      end
    end

    context "存在しない返信の詳細ページに遷移すると" do
      it "返信の取得に失敗する" do
        get book_question_reply_path(book, question, -1)
        expect(response).to have_http_status(404)
      end
    end

    context "参考書が存在しないと" do
      it "返信の取得に失敗する" do
        get book_question_reply_path(-1, question, reply)
        expect(response).to have_http_status(404)
      end
    end

    context "質問が存在しないと" do
      it "返信の取得に失敗する" do
        get book_question_reply_path(book, -1, reply)
        expect(response).to have_http_status(404)
      end
    end


  end

  describe "返信の新規投稿" do

    context "正しいパラメーターで返信を投稿すると" do
      it "返信の投稿に成功する" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')
        book = create(:book, user_id: user.id)
        question = create(:question, user_id: user.id, book_id: book.id)

        expect {
          post book_question_replies_path(book, question), params: {
            reply: {
              content: "テスト返信本文",
              image: image,
              user_id: user.id,
              question_id: question.id
            }
          }
        }.to change(Reply, :count).by(1)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        expect(json_response["content"]).to eq("テスト返信本文")

        get book_question_reply_path(book, question, json_response["id"])
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["reply"]["image"]).to include("no_image.png")
      end
    end

    context "不正なパラメーターで返信を投稿すると" do
      it "返信の投稿に失敗する" do
        expect {
          post book_question_replies_path(book, question), params: {
            reply: {
              content: "",
              user_id: user.id,
              question_id: question.id
            }
          }
        }.to change(Reply, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "質問の投稿に失敗する" do
        expect {
          post book_question_replies_path(book, question), params: {
            reply: {
              content: "テスト",
              user_id: -1,
              question_id: question.id
            }
          }
        }.to change(Reply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

    context "質問が存在しないと" do
      it "質問の投稿に失敗する" do
        expect {
          post book_question_replies_path(book, -1), params: {
            reply: {
              content: "",
              user_id: user.id,
              question_id: -1
            }
          }
        }.to change(Reply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "返信の編集" do

    context "正しいパラメーターで返信を編集すると" do
      it "返信の編集に成功する" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')
        book = create(:book, user_id: user.id)
        question = create(:question, user_id: user.id, book_id: book.id)
        reply = create(:reply, content: "テスト返信本文", user_id: user.id, question_id: question.id)

        expect(reply.content).to eq("テスト返信本文")

        patch book_question_reply_path(book, question, reply), params: {
          reply: {
            content: "変更後テスト返信本文",
            image: image,
            user_id: user.id,
          }
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["reply"]["content"]).to eq("変更後テスト返信本文")
          expect(json_response["image_url"]).to include("no_image.png")
        end
      end
    end

    context "不正なパラメーターで返信を編集すると" do
      it "返信の編集に失敗する" do
        book = create(:book, user_id: user.id)
        question = create(:question, user_id: user.id, book_id: book.id)
        reply = create(:reply, content: "テスト返信本文", user_id: user.id, question_id: question.id)

        patch book_question_reply_path(book, question, reply), params: {
          reply: {
            content: "",
            user_id: user.id,
          }
        }
        expect(response).to have_http_status(422)
      end
    end

    context "他人が投稿した返信を編集すると" do
      it "返信の編集に失敗する" do
        user2 = create(:user)
        book = create(:book, user_id: user.id)
        question = create(:question, user_id: user.id, book_id: book.id)
        reply = create(:reply, content: "テスト返信本文", user_id: user.id, question_id: question.id)

        patch book_question_reply_path(book, question, reply), params: {
          reply: {
            content: "変更後テスト返信本文",
            user_id: user2.id,
          }
        }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "返信の編集に失敗する" do
        patch book_question_reply_path(book, question, reply), params: {
          reply: {
            content: "テスト",
            user_id: -1,
            question_id: question.id
          }
        }
        expect(response).to have_http_status(404)
      end
    end

    context "返信が存在しないと" do
      it "返信の編集に失敗する" do
        patch book_question_reply_path(book, question, -1), params: {
          reply: {
            content: "",
            user_id: user.id,
            question_id: question.id
          }
        }
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "返信の削除" do

    context "自分が作成した返信を削除すると" do
      it "返信の削除に成功する" do
        reply = create(:reply, content: "テスト返信本文", user_id: user.id, question_id: question.id)
        expect {
          delete book_question_reply_path(book, question, reply), params: {
            current_user_id: user.id
          }
        }.to change(Reply, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

    context "他人が作成した返信を削除すると" do
      it "返信の削除に失敗する" do
        user2 = create(:user)
        reply = create(:reply, content: "テスト返信本文", user_id: user.id, question_id: question.id)
        expect {
          delete book_question_reply_path(book, question, reply), params: {
            current_user_id: user2.id
          }
        }.to change(Reply, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "返信の削除に失敗する" do
        user = create(:user)
        book = create(:book, user_id: user.id)
        question = create(:question, user_id: user.id, book_id: book.id)
        reply = create(:reply, user_id: user.id, question_id: question.id)
        expect {
          delete book_question_reply_path(book, question, reply), params: {
            current_user_id: -1
          }
        }.to change(Reply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

    context "返信が存在しないと" do
      it "返信の削除に失敗する" do
        reply = create(:reply, user_id: user.id, question_id: question.id)
        expect {
          delete book_question_reply_path(book, question, -1), params: {
            current_user_id: user.id
          }
        }.to change(Reply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end


  end

  describe "返信情報の取得" do

    context "check_existenceで存在する返信をチェックすると" do
      it "成功する" do
        get check_existence_replies_path, params: {
          book_id: book.id,
          question_id: question.id,
          id: reply.id
        }
        expect(response).to have_http_status(200)
      end
    end

    context "check_existenceで存在しない返信をチェックすると" do
      it "失敗する" do
        get check_existence_replies_path, params: {
          book_id: book.id,
          question_id: question.id,
          id: -1
        }
        expect(response).to have_http_status(404)
      end
    end

  end

end
