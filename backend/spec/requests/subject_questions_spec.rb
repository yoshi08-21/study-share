require 'rails_helper'

RSpec.describe "SubjectQuestions", type: :request do

  let(:user) { create(:user) }
  let(:subject_question) { create(:subject_question, user_id: user.id) }

  describe "質問の一覧表示" do
    context "質問が3件投稿されている状態で全科目別質問一覧ページに遷移すると" do
      it "3件の質問が表示される" do
        subject_question
        create(:subject_question, user_id: user.id)
        create(:subject_question, user_id: user.id)

        get subject_questions_path
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(3)
      end
    end
    context "質問が投稿されていない状態で全科目別質問一覧ページに遷移すると" do
      it "空の配列が返ってくる" do
        get subject_questions_path
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
        subject_question = create(:subject_question, title: "テストタイトル", content: "テスト本文", subject: "地理", image: image, user_id: user.id)

        get subject_question_path(subject_question), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question"]["title"]).to eq("テストタイトル")
          expect(json_response["subject_question"]["content"]).to eq("テスト本文")
          expect(json_response["subject_question"]["subject"]).to eq("地理")
          expect(json_response["subject_question"]["image"]).to include("no_image.png")
          expect(json_response["subject_question_user"]["name"]).to eq("質問投稿者")
        end
      end
    end
    context "存在しない質問の詳細ページに遷移すると" do
      it "質問の取得に失敗する" do
        get subject_question_path(-1), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "質問の新規投稿" do
    context "正しいパラメーターで質問を投稿すると" do
      it "質問の投稿に成功する" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')

        expect {
          post subject_questions_path, params: {
            subject_question: {
              title: "テスト質問タイトル",
              content: "テスト質問本文",
              subject: "世界史",
              image: image,
              user_id: user.id,
            }
          }
        }.to change(SubjectQuestion, :count).by(1)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["title"]).to eq("テスト質問タイトル")
          expect(json_response["content"]).to eq("テスト質問本文")
          expect(json_response["subject"]).to eq("世界史")
        end

        get subject_question_path(json_response["id"])
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_question"]["image"]).to include("no_image.png")
      end
    end
    context "不正なパラメーターで質問を投稿すると" do
      it "質問の投稿に失敗する" do
        expect {
          post subject_questions_path, params: {
            subject_question: {
              title: "",
              content: "",
              subject: "",
              user_id: user.id,
            }
          }
        }.to change(SubjectQuestion, :count).by(0)
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("エラーが発生しました")
      end
    end
  end
  describe "質問の編集" do
    context "正しいパラメーターで質問を編集すると" do
      it "質問の編集に成功する" do
        subject_question = create(:subject_question, title: "テストタイトル", content: "テスト本文", subject: "地理", user_id: user.id)
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')

        aggregate_failures do
          expect(subject_question.title).to eq("テストタイトル")
          expect(subject_question.content).to eq("テスト本文")
          expect(subject_question.subject).to eq("地理")
        end

        patch subject_question_path(subject_question), params: {
          subject_question: {
            title: "変更後タイトル",
            content: "変更後本文",
            subject: "日本史",
            image: image,
            user_id: user.id,
          }
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question"]["title"]).to eq("変更後タイトル")
          expect(json_response["subject_question"]["content"]).to eq("変更後本文")
          expect(json_response["subject_question"]["subject"]).to eq("日本史")
          expect(json_response["image_url"]).to include("no_image.png")
        end
      end
    end
    context "不正なパラメーターで質問を編集すると" do
      it "質問の編集に失敗する" do
        subject_question = create(:subject_question, title: "テストタイトル", content: "テスト本文", subject: "地理", user_id: user.id)

        patch subject_question_path(subject_question), params: {
          subject_question: {
            title: "",
            content: "",
            subject: "",
            user_id: user.id,
          }
        }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("エラーが発生しました")
      end
    end
    context "他人が投稿した質問を編集すると" do
      it "質問の編集に失敗する" do
        subject_question = create(:subject_question, title: "テストタイトル", content: "テスト本文", subject: "地理", user_id: user.id)
        user2 = create(:user)

        patch subject_question_path(subject_question), params: {
          subject_question: {
            title: "変更後タイトル",
            content: "変更後本文",
            subject: "世界史",
            user_id: user2.id,
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
        subject_question = create(:subject_question, title: "テストタイトル", content: "テスト本文", subject: "地理", user_id: user.id)
        expect {
          delete subject_question_path(subject_question), params: {
            current_user_id: user.id
          }
        }.to change(SubjectQuestion, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "他人が作成した質問を削除すると" do
      it "質問の削除に失敗する" do
        user2 = create(:user)
        subject_question = create(:subject_question, title: "テストタイトル", content: "テスト本文", subject: "地理", user_id: user.id)
        expect {
          delete subject_question_path(subject_question), params: {
            current_user_id: user2.id
          }
        }.to change(SubjectQuestion, :count).by(0)
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end
  end
  describe "質問情報の取得" do
    context "check_existenceで存在する質問をチェックすると" do
      it "成功する" do
        get check_existence_subject_questions_path, params: {
          id: subject_question.id
        }
        expect(response).to have_http_status(200)
      end
    end
    context "check_existenceで存在しない質問をチェックすると" do
      it "失敗する" do
        get check_existence_subject_questions_path, params: {
          id: -1
        }
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "質問の検索機能" do
    before :each do
      subject_question = create(:subject_question, title: "質問です", content: "to不定詞について教えてください", subject: "英文法", user_id: user.id)
      subject_question2 = create(:subject_question, title: "疑問があります", content: "織田信長とはどんな人ですか？", subject: "日本史", user_id: user.id)
    end
    context "質問をタイトルで検索すると" do
      it "キーワードが完全一致する質問が表示される" do
        get search_subject_questions_subject_questions_path, params: {
          searchSubjectQuestionsKeyword: "質問です"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_questions"][0]["title"]).to eq("質問です")
        expect(JSON.parse(response.body)["subject_questions_count"]).to eq(1)
      end

      it "キーワードが部分一致する質問が表示される" do
        get search_subject_questions_subject_questions_path, params: {
          searchSubjectQuestionsKeyword: "質問"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_questions"][0]["title"]).to eq("質問です")
        expect(JSON.parse(response.body)["subject_questions_count"]).to eq(1)
      end
    end
    context "質問を本文で検索すると" do
      it "キーワードが完全一致する質問が表示される" do
        get search_subject_questions_subject_questions_path, params: {
          searchSubjectQuestionsKeyword: "to不定詞について教えてください"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_questions"][0]["content"]).to eq("to不定詞について教えてください")
        expect(JSON.parse(response.body)["subject_questions_count"]).to eq(1)
      end

      it "キーワードが部分一致する質問が表示される" do
        get search_subject_questions_subject_questions_path, params: {
          searchSubjectQuestionsKeyword: "不定詞"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_questions"][0]["content"]).to eq("to不定詞について教えてください")
        expect(JSON.parse(response.body)["subject_questions_count"]).to eq(1)
      end
    end
    context "質問を科目で検索すると" do
      it "キーワードが完全一致する質問が表示される" do
        get search_subject_questions_subject_questions_path, params: {
          searchSubjectQuestionsKeyword: "英文法"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_questions"][0]["content"]).to eq("to不定詞について教えてください")
        expect(JSON.parse(response.body)["subject_questions_count"]).to eq(1)
      end

      it "キーワードが部分一致する質問が表示される" do
        get search_subject_questions_subject_questions_path, params: {
          searchSubjectQuestionsKeyword: "文法"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_questions"][0]["content"]).to eq("to不定詞について教えてください")
        expect(JSON.parse(response.body)["subject_questions_count"]).to eq(1)
      end
    end
    context "2件の質問が投稿されている状態で検索キーワードが2件の質問に一致すると" do
      it "2件の質問が表示される" do
        get search_subject_questions_subject_questions_path, params: {
          searchSubjectQuestionsKeyword: "す"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_questions"][0]["title"]).to eq("質問です")
        expect(JSON.parse(response.body)["subject_questions"][1]["title"]).to eq("疑問があります")
        expect(JSON.parse(response.body)["subject_questions_count"]).to eq(2)
      end
    end
    context "検索キーワードが質問に一致しないと" do
      it "質問が表示されない" do
        get search_subject_questions_subject_questions_path, params: {
          searchSubjectQuestionsKeyword: "国語"
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_questions_count"]).to eq(0)
      end
    end
  end
  describe "渡された質問の科目と同じ科目の質問を返す(questions_to_specific_subject)" do
    context "科目:英文法の質問が渡されると" do
      it "科目:英文法の質問の配列が返される" do
        subject_question1 = create(:subject_question, title: "英文法の教科書", content: "テスト本文", subject: "英文法", user_id: user.id)
        subject_question2 = create(:subject_question, title: "英作文の教科書", content: "テスト本文", subject: "英作文", user_id: user.id)
        subject_question3 = create(:subject_question, title: "英単語の教科書", content: "テスト本文", subject: "英単語", user_id: user.id)
        subject_question4 = create(:subject_question, title: "英文法の教科書2", content: "テスト本文", subject: "英文法", user_id: user.id)

        get questions_to_specific_subject_subject_questions_path, params: {
          subject_question_id: subject_question1.id
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(2)
      end
    end
  end



end
