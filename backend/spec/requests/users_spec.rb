require 'rails_helper'

RSpec.describe "Users", type: :request do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:book) { create(:book, user_id: user.id) }
  let(:review) { create(:review, user_id: user.id, book_id: book.id) }
  let(:question) { create(:question, user_id: user.id ,book_id: book.id) }
  let(:reply) { create(:reply, user_id: user.id, question_id: question.id) }
  let(:subject_question) { create(:subject_question, user_id: user.id) }
  let(:subject_question_reply) { create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id) }
  let(:survey) { create(:survey, user_id: user.id) }
  let(:survey_answer) { create(:survey_answer, user_id: user2.id, survey_id: survey.id) }



  describe "ユーザー登録" do

    context "不正なパラメーターでユーザー登録すると" do
      it "ユーザー登録に失敗する" do
        expect {
          post users_path, params: {
            user: {
              name: "",
              email: "@sample.com",
              uid: ""
            }
          }
        }.to change(User, :count).by(0)

        expect(response).to have_http_status(422)
      end
    end

  end

  describe "ユーザー編集" do

    context "正しいパラメーターでユーザー編集すると" do
      it "ユーザー編集に成功する" do
        expect(user.name).not_to eq("神奈川太郎")
        expect(user.introduction).not_to eq("")
        expect(user.first_choice_school).not_to eq("")
        expect(user.second_choice_school).not_to eq("")
        expect(user.third_choice_school).not_to eq("")

        patch user_path(user), params: {
          user: {
            name: "東京一郎",
            introduction: "よろしくお願いします!",
            first_choice_school: "A大学",
            second_choice_school: "B大学",
            third_choice_school: "C大学"
          }
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["user"]["name"]).to eq("東京一郎")
          expect(json_response["user"]["introduction"]).to eq("よろしくお願いします!")
          expect(json_response["user"]["first_choice_school"]).to eq("A大学")
          expect(json_response["user"]["second_choice_school"]).to eq("B大学")
          expect(json_response["user"]["third_choice_school"]).to eq("C大学")
        end
      end
    end

    context "不正なパラメーターでユーザー編集すると" do
      it "ユーザー編集に失敗する" do
        patch user_path(user), params: {
          user: {
            name: "",
          }
        }
        expect(response).to have_http_status(422)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "ユーザー編集に失敗する" do
        patch user_path(-1), params: {
          user: {
            name: "東京一郎",
            introduction: "よろしくお願いします!",
            first_choice_school: "A大学",
            second_choice_school: "B大学",
            third_choice_school: "C大学"
          }
        }
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "ユーザー削除" do

    context "admin属性のついていないユーザーを削除すると" do
      it "ユーザー削除に成功する" do
        user = create(:user)
        expect {
          delete user_path(user)
        }.to change(User, :count).by(-1)

        expect(response).to have_http_status(204)
      end
    end

    context "admin属性のついているユーザーを削除すると" do
      it "ユーザー削除に失敗する" do
        user = create(:user, admin: true)
        expect {
          delete user_path(user)
        }.to change(User, :count).by(0)

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("このユーザーは削除できません")
      end
    end

    context "ログインしていない(current_userがいない)と" do
      it "ユーザー削除に失敗する" do
        delete user_path(-1)
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "ユーザーのマイページ" do

    context "ログインした状態でマイページにアクセスすると" do
      it "自分の情報を取得できる" do
        user = create(:user, name: "東京一郎")

        get user_path(user)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["user"]["name"]).to eq("東京一郎")
      end
    end

    context "レビューを投稿している状態でマイページにアクセスすると" do
      it "自分が投稿したレビューを取得できる" do
        user = create(:user, name: "東京一郎")
        book = create(:book, name: "サンプル参考書", user_id: user.id)
        review = create(:review, title: "サンプルレビュータイトル", content: "サンプルレビュー本文", rating: 5, user_id: user.id, book_id: book.id)
        create(:favorite_review, user_id: user2.id, review_id: review.id)

        get user_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_reviews"].length).to eq(1)
          expect(json_response["my_reviews"][0]["title"]).to eq("サンプルレビュータイトル")
          expect(json_response["my_reviews"][0]["content"]).to eq("サンプルレビュー本文")
          expect(json_response["my_reviews"][0]["rating"]).to eq(5)
          expect(json_response["my_reviews"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_reviews"][0]["book"]["name"]).to eq("サンプル参考書")
          expect(json_response["my_reviews"][0]["favorite_reviews_count"]).to eq(1)
          expect(json_response["my_favorite_reviews_count"]).to eq(1)
        end
      end
    end

    context "質問を投稿している状態でマイページにアクセスすると" do
      it "自分が投稿した質問を取得できる" do
        user = create(:user, name: "東京一郎")
        book = create(:book, name: "サンプル参考書", user_id: user.id)
        question = create(:question, title: "サンプル質問タイトル", content: "サンプル質問本文", user_id: user.id, book_id: book.id)
        create(:favorite_question, user_id: user2.id, question_id: question.id)
        create(:reply, user_id: user2.id, question_id: question.id)

        get user_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_questions"].length).to eq(1)
          expect(json_response["my_questions"][0]["title"]).to eq("サンプル質問タイトル")
          expect(json_response["my_questions"][0]["content"]).to eq("サンプル質問本文")
          expect(json_response["my_questions"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_questions"][0]["book"]["name"]).to eq("サンプル参考書")
          expect(json_response["my_questions"][0]["favorite_questions_count"]).to eq(1)
          expect(json_response["my_questions"][0]["replies_count"]).to eq(1)
          expect(json_response["my_favorite_questions_count"]).to eq(1)
        end
      end
    end

    context "返信を投稿している状態でマイページにアクセスすると" do
      it "自分が投稿した返信を取得できる" do
        user = create(:user, name: "東京一郎")
        book = create(:book, name: "サンプル参考書", user_id: user.id)
        question = create(:question, title: "サンプル質問タイトル", content: "サンプル質問本文", user_id: user.id, book_id: book.id)
        reply = create(:reply, content: "サンプル返信本文", user_id: user.id, question_id: question.id)
        create(:favorite_reply, user_id: user2.id, reply_id: reply.id)

        get user_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_replies"].length).to eq(1)
          expect(json_response["my_replies"][0]["content"]).to eq("サンプル返信本文")
          expect(json_response["my_replies"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_replies"][0]["question"]["title"]).to eq("サンプル質問タイトル")
          expect(json_response["my_replies"][0]["favorite_replies_count"]).to eq(1)
          expect(json_response["my_favorite_replies_count"]).to eq(1)
        end
      end
    end

    context "質問(科目別)を投稿している状態でマイページにアクセスすると" do
      it "自分が投稿した質問(科目別)を取得できる" do
        user = create(:user, name: "東京一郎")
        subject_question = create(:subject_question, title: "サンプル科目別質問タイトル", content: "サンプル科目別質問本文", subject: "漢文", user_id: user.id)
        create(:subject_question_reply, user_id: user2.id, subject_question_id: subject_question.id)
        create(:favorite_subject_question, user_id: user2.id, subject_question_id: subject_question.id)

        get user_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_subject_questions"].length).to eq(1)
          expect(json_response["my_subject_questions"][0]["title"]).to eq("サンプル科目別質問タイトル")
          expect(json_response["my_subject_questions"][0]["content"]).to eq("サンプル科目別質問本文")
          expect(json_response["my_subject_questions"][0]["subject"]).to eq("漢文")
          expect(json_response["my_subject_questions"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_subject_questions"][0]["favorite_subject_questions_count"]).to eq(1)
          expect(json_response["my_subject_questions"][0]["subject_question_replies_count"]).to eq(1)
          expect(json_response["my_favorite_subject_questions_count"]).to eq(1)
        end
      end
    end

    context "返信(科目別)を投稿している状態でマイページにアクセスすると" do
      it "自分が投稿した返信(科目別)を取得できる" do
        user = create(:user, name: "東京一郎")
        subject_question = create(:subject_question, title: "サンプル科目別質問タイトル", content: "サンプル科目別質問本文", subject: "漢文", user_id: user.id)
        subject_question_reply = create(:subject_question_reply, content: "サンプル科目別質問返信本文", user_id: user.id, subject_question_id: subject_question.id)
        create(:favorite_subject_question_reply, user_id: user2.id, subject_question_reply_id: subject_question_reply.id)

        get user_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_subject_question_replies"].length).to eq(1)
          expect(json_response["my_subject_question_replies"][0]["content"]).to eq("サンプル科目別質問返信本文")
          expect(json_response["my_subject_question_replies"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_subject_question_replies"][0]["subject_question"]["title"]).to eq("サンプル科目別質問タイトル")
          expect(json_response["my_subject_question_replies"][0]["favorite_subject_question_replies_count"]).to eq(1)
          expect(json_response["my_favorite_subject_question_replies_count"]).to eq(1)
        end
      end
    end

    context "アンケートを作成している状態でマイページにアクセスすると" do
      it "自分が作成したアンケートを取得できる" do
        user = create(:user, name: "東京一郎")
        survey = create(:survey, title: "サンプルアンケートタイトル", content: "サンプルアンケート本文", genre: "国語", status: false, user_id: user.id)
        create(:survey_answer, user_id: user2.id, survey_id: survey.id)
        create(:favorite_survey, user_id: user2.id, survey_id: survey.id)

        get user_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_surveys"].length).to eq(1)
          expect(json_response["my_surveys"][0]["title"]).to eq("サンプルアンケートタイトル")
          expect(json_response["my_surveys"][0]["content"]).to eq("サンプルアンケート本文")
          expect(json_response["my_surveys"][0]["genre"]).to eq("国語")
          expect(json_response["my_surveys"][0]["status"]).to eq(false)
          expect(json_response["my_surveys"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_surveys"][0]["survey_answers_count"]).to eq(1)
          expect(json_response["my_surveys"][0]["favorite_surveys_count"]).to eq(1)
          expect(json_response["my_favorite_surveys_count"]).to eq(1)
        end
      end
    end

    context "ログインしていない状態でマイページにアクセスすると" do
      it "情報の取得に失敗する" do
        get user_path(-1)
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "他ユーザーの詳細ページ" do

    context "存在する他ユーザーの詳細ページにアクセスすると" do
      it "他ユーザーの詳細情報を取得できる" do
        @user2 = create(:user, name: "京都二郎")

        get show_other_user_users_path(@user2)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["user"]["name"]).to eq("京都二郎")
      end
    end

    context "存在しないユーザーの詳細ページにアクセスすると" do
      it "エラーになる" do
        get show_other_user_users_path(-1)
        expect(response).to have_http_status(404)
      end
    end

    context "レビューを投稿している状態で他ユーザーのページにアクセスすると" do
      it "他ユーザーが投稿したレビューを取得できる" do
        user = create(:user, name: "東京一郎")
        book = create(:book, name: "サンプル参考書", user_id: user.id)
        review = create(:review, title: "サンプルレビュータイトル", content: "サンプルレビュー本文", rating: 5, user_id: user.id, book_id: book.id)
        create(:favorite_review, user_id: user2.id, review_id: review.id)

        get show_other_user_users_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_reviews"].length).to eq(1)
          expect(json_response["my_reviews"][0]["title"]).to eq("サンプルレビュータイトル")
          expect(json_response["my_reviews"][0]["content"]).to eq("サンプルレビュー本文")
          expect(json_response["my_reviews"][0]["rating"]).to eq(5)
          expect(json_response["my_reviews"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_reviews"][0]["book"]["name"]).to eq("サンプル参考書")
          expect(json_response["my_reviews"][0]["favorite_reviews_count"]).to eq(1)
          expect(json_response["my_favorite_reviews_count"]).to eq(1)
        end
      end
    end

    context "質問を投稿している状態で他ユーザーのページにアクセスすると" do
      it "他ユーザーが投稿した質問を取得できる" do
        user = create(:user, name: "東京一郎")
        book = create(:book, name: "サンプル参考書", user_id: user.id)
        question = create(:question, title: "サンプル質問タイトル", content: "サンプル質問本文", user_id: user.id, book_id: book.id)
        create(:favorite_question, user_id: user2.id, question_id: question.id)
        create(:reply, user_id: user2.id, question_id: question.id)

        get show_other_user_users_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_questions"].length).to eq(1)
          expect(json_response["my_questions"][0]["title"]).to eq("サンプル質問タイトル")
          expect(json_response["my_questions"][0]["content"]).to eq("サンプル質問本文")
          expect(json_response["my_questions"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_questions"][0]["book"]["name"]).to eq("サンプル参考書")
          expect(json_response["my_questions"][0]["favorite_questions_count"]).to eq(1)
          expect(json_response["my_questions"][0]["replies_count"]).to eq(1)
          expect(json_response["my_favorite_questions_count"]).to eq(1)
        end
      end
    end

    context "返信を投稿している状態で他ユーザーのページにアクセスすると" do
      it "他ユーザーが投稿した返信を取得できる" do
        user = create(:user, name: "東京一郎")
        book = create(:book, name: "サンプル参考書", user_id: user.id)
        question = create(:question, title: "サンプル質問タイトル", content: "サンプル質問本文", user_id: user.id, book_id: book.id)
        reply = create(:reply, content: "サンプル返信本文", user_id: user.id, question_id: question.id)
        create(:favorite_reply, user_id: user2.id, reply_id: reply.id)

        get show_other_user_users_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_replies"].length).to eq(1)
          expect(json_response["my_replies"][0]["content"]).to eq("サンプル返信本文")
          expect(json_response["my_replies"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_replies"][0]["question"]["title"]).to eq("サンプル質問タイトル")
          expect(json_response["my_replies"][0]["favorite_replies_count"]).to eq(1)
          expect(json_response["my_favorite_replies_count"]).to eq(1)
        end
      end
    end

    context "質問(科目別)を投稿している状態で他ユーザーのページにアクセスすると" do
      it "他ユーザーが投稿した質問(科目別)を取得できる" do
        user = create(:user, name: "東京一郎")
        subject_question = create(:subject_question, title: "サンプル科目別質問タイトル", content: "サンプル科目別質問本文", subject: "漢文", user_id: user.id)
        create(:subject_question_reply, user_id: user2.id, subject_question_id: subject_question.id)
        create(:favorite_subject_question, user_id: user2.id, subject_question_id: subject_question.id)

        get show_other_user_users_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_subject_questions"].length).to eq(1)
          expect(json_response["my_subject_questions"][0]["title"]).to eq("サンプル科目別質問タイトル")
          expect(json_response["my_subject_questions"][0]["content"]).to eq("サンプル科目別質問本文")
          expect(json_response["my_subject_questions"][0]["subject"]).to eq("漢文")
          expect(json_response["my_subject_questions"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_subject_questions"][0]["favorite_subject_questions_count"]).to eq(1)
          expect(json_response["my_subject_questions"][0]["subject_question_replies_count"]).to eq(1)
          expect(json_response["my_favorite_subject_questions_count"]).to eq(1)
        end
      end
    end

    context "返信(科目別)を投稿している状態で他ユーザーのページにアクセスすると" do
      it "他ユーザーが投稿した返信(科目別)を取得できる" do
        user = create(:user, name: "東京一郎")
        subject_question = create(:subject_question, title: "サンプル科目別質問タイトル", content: "サンプル科目別質問本文", subject: "漢文", user_id: user.id)
        subject_question_reply = create(:subject_question_reply, content: "サンプル科目別質問返信本文", user_id: user.id, subject_question_id: subject_question.id)
        create(:favorite_subject_question_reply, user_id: user2.id, subject_question_reply_id: subject_question_reply.id)

        get show_other_user_users_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_subject_question_replies"].length).to eq(1)
          expect(json_response["my_subject_question_replies"][0]["content"]).to eq("サンプル科目別質問返信本文")
          expect(json_response["my_subject_question_replies"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_subject_question_replies"][0]["subject_question"]["title"]).to eq("サンプル科目別質問タイトル")
          expect(json_response["my_subject_question_replies"][0]["favorite_subject_question_replies_count"]).to eq(1)
          expect(json_response["my_favorite_subject_question_replies_count"]).to eq(1)
        end
      end
    end

    context "アンケートを作成している状態で他ユーザーのページにアクセスすると" do
      it "他ユーザーが作成したアンケートを取得できる" do
        user = create(:user, name: "東京一郎")
        survey = create(:survey, title: "サンプルアンケートタイトル", content: "サンプルアンケート本文", genre: "国語", status: false, user_id: user.id)
        create(:survey_answer, user_id: user2.id, survey_id: survey.id)
        create(:favorite_survey, user_id: user2.id, survey_id: survey.id)

        get show_other_user_users_path(user)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["my_surveys"].length).to eq(1)
          expect(json_response["my_surveys"][0]["title"]).to eq("サンプルアンケートタイトル")
          expect(json_response["my_surveys"][0]["content"]).to eq("サンプルアンケート本文")
          expect(json_response["my_surveys"][0]["genre"]).to eq("国語")
          expect(json_response["my_surveys"][0]["status"]).to eq(false)
          expect(json_response["my_surveys"][0]["user"]["name"]).to eq("東京一郎")
          expect(json_response["my_surveys"][0]["survey_answers_count"]).to eq(1)
          expect(json_response["my_surveys"][0]["favorite_surveys_count"]).to eq(1)
          expect(json_response["my_favorite_surveys_count"]).to eq(1)
        end
      end
    end

  end

  describe "ユーザーメモ機能" do

    context "ログイン状態でユーザーメモを更新すると" do
      it "ユーザーメモの更新に成功する" do
        expect(user.memo).to eq(nil)

        patch save_user_memo_users_path, params: {
          current_user_id: user.id,
          memo: "ユーザーメモ"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["memo"]).to eq("ユーザーメモ")
      end
    end

    context "未ログイン状態でユーザーメモを更新すると" do
      it "ユーザーメモの更新に失敗する" do
        patch save_user_memo_users_path, params: {
          current_user_id: -1,
          memo: "ユーザーメモ"
        }
        expect(response).to have_http_status(404)
        expect(response.body).to include("ユーザーが見つかりません")
      end
    end

  end

  describe "ユーザー情報の取得" do

    context "check_existenceで存在するユーザーをチェックすると" do
      it "成功する" do
        get check_existence_users_path, params: {
          id: user.id
        }
        expect(response).to have_http_status(200)
      end
    end

    context "check_existenceで存在しないユーザーをチェックすると" do
      it "失敗する" do
        get check_existence_users_path, params: {
          id: -1
        }
        expect(response).to have_http_status(404)
      end
    end

    context "ユーザーを正しいuidで検索すると" do
      it "検索に成功する" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')
        user = create(:user, name: "神奈川太郎", uid: "111", image: image)
        expect(user.name).to eq("神奈川太郎")
        expect(user.uid).to eq("111")

        get find_user_by_uid_users_path(user.uid)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["name"]).to eq("神奈川太郎")
          expect(json_response["uid"]).to eq("111")
          expect(json_response["image"]).to include("no_image.png")
        end
      end
    end

    context "ユーザーを不正なuidで検索すると" do
      it "検索に失敗する" do
        user = create(:user, name: "神奈川太郎", uid: "111")
        expect(user.name).to eq("神奈川太郎")
        expect(user.uid).to eq("111")

        get find_user_by_uid_users_path("112")
        expect(response).to have_http_status(404)
      end
    end

  end








end
