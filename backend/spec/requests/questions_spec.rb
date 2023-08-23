require 'rails_helper'

RSpec.describe "Questions", type: :request do

  let(:user) { create(:user) }
  let(:book) { create(:book, user_id: user.id) }
  let(:question) { create(:question, user_id: user.id, book_id: book.id) }

  describe "質問の一覧表示" do
    context "参考書に3件の質問が投稿されていると" do
      it "3件の質問が表示される" do
        question
        create(:question, user_id: user.id, book_id: book.id)
        create(:question, user_id: user.id, book_id: book.id)

        get book_questions_path(book)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(3)
      end
    end
    context "参考書に質問が投稿されていないと" do
      it "空の配列が返ってくる" do
        get book_questions_path(book)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(0)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
    context "質問が3件投稿されている状態で全質問一覧ページに遷移すると" do
      it "3件の質問が表示される" do
        question
        create(:question, user_id: user.id, book_id: book.id)
        create(:question, user_id: user.id, book_id: book.id)

        get all_questions_questions_path
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(3)
      end
    end
    context "質問が投稿されていない状態で全質問一覧ページに遷移すると" do
      it "空の配列が返ってくる" do
        get all_questions_questions_path
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(0)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
  describe "質問の詳細表示" do
    context "存在する質問の詳細ページに遷移すると" do
      it "質問の詳細情報が取得できる" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')
        user = create(:user, name: "質問投稿者")
        book = create(:book, name: "数学の参考書", subject: "数学", user_id: user.id)
        question = create(:question, title: "テストタイトル", content: "テスト本文", subject: book.subject, image: image, user_id: user.id, book_id: book.id)

        get book_question_path(book, question)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["book"]["name"]).to eq("数学の参考書")
          expect(json_response["question"]["title"]).to eq("テストタイトル")
          expect(json_response["question"]["content"]).to eq("テスト本文")
          expect(json_response["question"]["subject"]).to eq("数学")
          expect(json_response["question"]["image"]).to include("no_image.png")
          expect(json_response["question_user"]["name"]).to eq("質問投稿者")
        end
      end
    end
    context "存在しない質問の詳細ページに遷移すると" do
      it "質問の取得に失敗する" do
        get book_question_path(book, -1)
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "質問の新規投稿" do
    context "正しいパラメーターで質問を投稿すると" do
      it "質問の投稿に成功する" do
        book = create(:book, subject: "日本史", user_id: user.id)
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')

        expect {
          post book_questions_path(book), params: {
            question: {
              title: "テスト質問タイトル",
              content: "テスト質問本文",
              subject: book.subject,
              image: image,
              user_id: user.id,
              book_id: book.id
            }
          }
        }.to change(Question, :count).by(1)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["title"]).to eq("テスト質問タイトル")
          expect(json_response["content"]).to eq("テスト質問本文")
          expect(json_response["subject"]).to eq("日本史")
        end

        get book_question_path(book, json_response["id"])
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["question"]["image"]).to include("no_image.png")
      end
    end
    context "不正なパラメーターで質問を投稿すると" do
      it "質問の投稿に失敗する" do
        expect {
          post book_questions_path(book), params: {
            question: {
              title: "",
              content: "",
              subject: "",
              user_id: user.id,
              book_id: book.id
            }
          }
        }.to change(Question, :count).by(0)
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("エラーが発生しました")
      end
    end
  end
  describe "質問の編集" do
    context "正しいパラメーターで質問を編集すると" do
      it "質問の編集に成功する" do
        book = create(:book, subject: "数学", user_id: user.id)
        question = create(:question, title: "テストタイトル", content: "テスト本文", subject: book.subject, user_id: user.id, book_id: book.id)
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')

        aggregate_failures do
          expect(question.title).to eq("テストタイトル")
          expect(question.content).to eq("テスト本文")
          expect(question.subject).to eq("数学")
        end

        patch book_question_path(book, question), params: {
          question: {
            title: "変更後タイトル",
            content: "変更後本文",
            subject: "世界史",
            image: image,
            user_id: user.id,
            book_id: book.id
          }
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["question"]["title"]).to eq("変更後タイトル")
          expect(json_response["question"]["content"]).to eq("変更後本文")
          expect(json_response["question"]["subject"]).to eq("世界史")
          expect(json_response["image_url"]).to include("no_image.png")
        end
      end
    end
    context "不正なパラメーターで質問を編集すると" do
      it "質問の編集に失敗する" do
        question = create(:question, title: "テストタイトル", content: "テスト本文", subject: book.subject, user_id: user.id, book_id: book.id)

        patch book_question_path(book, question), params: {
          question: {
            title: "",
            content: "",
            subject: "",
            user_id: user.id,
            book_id: book.id
          }
        }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("エラーが発生しました")
      end
    end
    context "他人が投稿した質問を編集すると" do
      it "質問の編集に失敗する" do
        question = create(:question, title: "テストタイトル", content: "テスト本文", subject: book.subject, user_id: user.id, book_id: book.id)
        user2 = create(:user)

        patch book_question_path(book, question), params: {
          question: {
            title: "変更後タイトル",
            content: "変更後本文",
            subject: "世界史",
            user_id: user2.id,
            book_id: book.id
          }
        }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end
  end
  describe "質問の削除" do
    context "自分が作成した質問を削除すると" do
      it "質問の削除に成功する" do
        question = create(:question, title: "テストタイトル", content: "テスト本文", subject: book.subject, user_id: user.id, book_id: book.id)
        expect {
          delete book_question_path(book, question), params: {
            current_user_id: user.id
          }
        }.to change(Question, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "他人が作成した質問を削除すると" do
      it "質問の削除に失敗する" do
        user2 = create(:user)
        question = create(:question, title: "テストタイトル", content: "テスト本文", subject: book.subject, user_id: user.id, book_id: book.id)
        expect {
          delete book_question_path(book, question), params: {
            current_user_id: user2.id
          }
        }.to change(Question, :count).by(0)
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end
  end
  describe "質問情報の取得" do
    context "check_existenceで存在する質問をチェックすると" do
      it "成功する" do
        get check_existence_questions_path, params: {
          book_id: book.id,
          id: question.id
        }
        expect(response).to have_http_status(200)
      end
    end
    context "check_existenceで存在しない質問をチェックすると" do
      it "失敗する" do
        get check_existence_questions_path, params: {
          book_id: book.id,
          id: -1
        }
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "質問の検索機能" do
    before :each do
      book = create(:book, name: "英文法の参考書", subject: "英文法", user_id: user.id)
      question = create(:question, title: "質問です", content: "この本の特徴を教えてください", subject: book.subject, user_id: user.id, book_id: book.id)
      question2 = create(:question, title: "疑問があります", content: "この書物の強みはなんですか", subject: "世界史", user_id: user.id, book_id: book.id)
    end
    context "質問をタイトルで検索すると" do
      it "キーワードが完全一致する質問が表示される" do
        get search_questions_questions_path, params: {
          searchQuestionsKeyword: "質問です"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["questions"][0]["title"]).to eq("質問です")
        expect(JSON.parse(response.body)["questions_count"]).to eq(1)
      end

      it "キーワードが部分一致する質問が表示される" do
        get search_questions_questions_path, params: {
          searchQuestionsKeyword: "質問"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["questions"][0]["title"]).to eq("質問です")
        expect(JSON.parse(response.body)["questions_count"]).to eq(1)
      end
    end
    context "質問を本文で検索すると" do
      it "キーワードが完全一致する質問が表示される" do
        get search_questions_questions_path, params: {
          searchQuestionsKeyword: "この本の特徴を教えてください"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["questions"][0]["content"]).to eq("この本の特徴を教えてください")
        expect(JSON.parse(response.body)["questions_count"]).to eq(1)
      end

      it "キーワードが部分一致する質問が表示される" do
        get search_questions_questions_path, params: {
          searchQuestionsKeyword: "本の特徴"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["questions"][0]["content"]).to eq("この本の特徴を教えてください")
        expect(JSON.parse(response.body)["questions_count"]).to eq(1)
      end
    end
    context "質問を科目で検索すると" do
      it "キーワードが完全一致する質問が表示される" do
        get search_questions_questions_path, params: {
          searchQuestionsKeyword: "英文法"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["questions"][0]["content"]).to eq("この本の特徴を教えてください")
        expect(JSON.parse(response.body)["questions_count"]).to eq(1)
      end

      it "キーワードが部分一致する質問が表示される" do
        get search_questions_questions_path, params: {
          searchQuestionsKeyword: "文法"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["questions"][0]["content"]).to eq("この本の特徴を教えてください")
        expect(JSON.parse(response.body)["questions_count"]).to eq(1)
      end
    end
    context "2件の質問が投稿されている状態で検索キーワードが2件の質問に一致すると" do
      it "2件の質問が表示される" do
        get search_questions_questions_path, params: {
          searchQuestionsKeyword: "す"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["questions"][0]["title"]).to eq("質問です")
        expect(JSON.parse(response.body)["questions"][1]["title"]).to eq("疑問があります")
        expect(JSON.parse(response.body)["questions_count"]).to eq(2)
      end
    end
    context "検索キーワードが質問に一致しないと" do
      it "質問が表示されない" do
        get search_questions_questions_path, params: {
          searchQuestionsKeyword: "国語"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["questions_count"]).to eq(0)
      end
    end
  end





end
