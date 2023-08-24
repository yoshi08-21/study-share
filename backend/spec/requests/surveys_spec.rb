require 'rails_helper'

RSpec.describe "Surveys", type: :request do

  let(:user) { create(:user) }
  let(:survey) { create(:survey, user_id: user.id) }

  describe "アンケートの一覧表示" do
    context "アンケートが3件作成されている状態でアンケート一覧ページに遷移すると" do
      it "3件のアンケートが表示される" do
        survey
        create(:survey, user_id: user.id)
        create(:survey, user_id: user.id)

        get surveys_path
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(3)
      end
    end
    context "アンケートが投稿されていない状態でアンケート一覧ページに遷移すると" do
      it "空の配列が返ってくる" do
        get surveys_path
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(0)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
  describe "アンケートの詳細表示" do
    context "存在するアンケートの詳細ページに遷移すると" do
      it "アンケートの詳細情報が取得できる" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')
        user = create(:user, name: "アンケート作成者")
        survey = create(:survey, title: "テストタイトル", content: "テスト本文", option1: "選択肢1", option2: "選択肢2", option3: "選択肢3", option4: "選択肢4", genre: "英語", image: image, user_id: user.id)

        get survey_path(survey), params: {
          user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["survey"]["title"]).to eq("テストタイトル")
          expect(json_response["survey"]["content"]).to eq("テスト本文")
          expect(json_response["survey"]["option1"]).to eq("選択肢1")
          expect(json_response["survey"]["option2"]).to eq("選択肢2")
          expect(json_response["survey"]["option3"]).to eq("選択肢3")
          expect(json_response["survey"]["option4"]).to eq("選択肢4")
          expect(json_response["survey"]["status"]).to eq(false)
          expect(json_response["survey"]["genre"]).to eq("英語")
          expect(json_response["survey"]["image"]).to include("no_image.png")
          expect(json_response["survey_user"]["name"]).to eq("アンケート作成者")
        end
      end
    end
    context "存在しないアンケートの詳細ページに遷移すると" do
      it "アンケートの取得に失敗する" do
        get survey_path(-1), params: {
          user_id: user.id
        }
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "アンケートの新規作成" do
    context "正しいパラメーターでアンケートを作成すると" do
      it "アンケートの作成に成功する" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')

        expect {
          post surveys_path, params: {
            survey: {
              title: "テストアンケートタイトル",
              content: "テストアンケート本文",
              option1: "選択肢1",
              option2: "選択肢2",
              option3: "選択肢3",
              option4: "選択肢4",
              status: 0,
              genre: "数学",
              image: image,
              user_id: user.id
            }
          }
        }.to change(Survey, :count).by(1)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["title"]).to eq("テストアンケートタイトル")
          expect(json_response["content"]).to eq("テストアンケート本文")
          expect(json_response["option1"]).to eq("選択肢1")
          expect(json_response["option2"]).to eq("選択肢2")
          expect(json_response["option3"]).to eq("選択肢3")
          expect(json_response["option4"]).to eq("選択肢4")
          expect(json_response["status"]).to eq(false)
          expect(json_response["genre"]).to eq("数学")
        end

        get survey_path(json_response["id"])
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["survey"]["image"]).to include("no_image.png")
      end
    end
    context "不正なパラメーターでアンケートを作成すると" do
      it "アンケートの作成に失敗する" do
        expect {
          post surveys_path, params: {
            survey: {
              title: "",
              content: "",
              option1: "",
              option2: "",
              status: 0,
              genre: "",
              user_id: user.id
            }
          }
        }.to change(Survey, :count).by(0)
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("エラーが発生しました")
      end
    end
  end
  describe "アンケートの削除機能" do
    context "自分が作成したアンケートを削除すると" do
      it "アンケートの削除に成功する" do
        user = create(:user, name: "アンケート作成者")
        survey = create(:survey, title: "テストタイトル", content: "テスト本文", option1: "選択肢1", option2: "選択肢2", option3: "選択肢3", option4: "選択肢4", genre: "英語", user_id: user.id)

        expect {
          delete survey_path(survey), params: {
            user_id: user.id
          }
        }.to change(Survey, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "他人が作成したアンケートを削除すると" do
      it "アンケートの削除に失敗する" do
        user = create(:user, name: "アンケート作成者")
        user2 = create(:user)
        survey = create(:survey, title: "テストタイトル", content: "テスト本文", option1: "選択肢1", option2: "選択肢2", option3: "選択肢3", option4: "選択肢4", genre: "英語", user_id: user.id)

        expect {
          delete survey_path(survey), params: {
            user_id: user2.id
          }
        }.to change(Survey, :count).by(0)
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end
  end
  describe "アンケートの締め切り機能" do
    context "自分が作成したアンケートを締め切ると" do
      it "アンケートの締切に成功する" do
        user = create(:user, name: "アンケート作成者")
        survey = create(:survey, title: "テストタイトル", content: "テスト本文", option1: "選択肢1", option2: "選択肢2", status: 0, genre: "英語", user_id: user.id)

        patch close_survey_survey_path(survey), params: {
          user_id: user.id
        }
        expect(response).to have_http_status(200)

        get survey_path(survey), params: {
          user_id: user.id
        }
        expect(JSON.parse(response.body)["survey"]["status"]).to eq(true)
      end
    end
    context "他人が作成したアンケートを締め切ると" do
      it "アンケートの締切に失敗する" do
        user = create(:user, name: "アンケート作成者")
        user2 = create(:user)
        survey = create(:survey, title: "テストタイトル", content: "テスト本文", option1: "選択肢1", option2: "選択肢2", status: 0, genre: "英語", user_id: user.id)

        patch close_survey_survey_path(survey), params: {
          user_id: user2.id
        }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end
  end
  describe "アンケート情報の取得" do
    context "check_existenceで存在するアンケートをチェックすると" do
      it "成功する" do
        get check_existence_surveys_path, params: {
          id: survey.id
        }
        expect(response).to have_http_status(200)
      end
    end
    context "check_existenceで存在しないアンケートをチェックすると" do
      it "失敗する" do
        get check_existence_surveys_path, params: {
          id: -1
        }
        expect(response).to have_http_status(404)
      end
    end
  end






end
