require 'rails_helper'

RSpec.describe "FavoriteSurveys", type: :request do

  let(:user) { create(:user) }
  let(:survey) { create(:survey, user_id: user.id) }
  let(:favorite_survey) { create(:favorite_survey, user_id: user.id, survey_id: survey.id) }

  describe "いいねへの登録" do
    context "ユーザーとアンケートが存在し、他人のアンケートへのいいねに成功すると" do
      it "アンケートのいいねが成功する" do
        user2 = create(:user)
        survey = create(:survey, user_id: user2.id)

        expect {
          post survey_favorite_surveys_path(survey), params: {
            user_id: user.id
          }
        }.to change(FavoriteSurvey, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいねに失敗する" do
        expect {
          post survey_favorite_surveys_path(survey), params: {
            user_id: -1
          }
        }.to change(FavoriteSurvey, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "アンケートが存在しないと" do
      it "いいねに失敗する" do
        expect {
          post survey_favorite_surveys_path(-1), params: {
            user_id: user.id
          }
        }.to change(FavoriteSurvey, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "自分のアンケートにいいねすると" do
      it "いいねに失敗する" do
        survey = create(:survey, user_id: user.id)

        expect {
          post survey_favorite_surveys_path(survey), params: {
            user_id: user.id
          }
        }.to change(FavoriteSurvey, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("自分のアンケートにはいいねできません")
      end
    end
    context "ユーザーがすでにアンケートにいいねしている場合" do
      it "いいねに失敗する" do
        user2 = create(:user)
        survey = create(:survey, user_id: user2.id)
        favorite_survey = create(:favorite_survey, user_id: user.id, survey_id: survey.id)

        expect {
          post survey_favorite_surveys_path(survey), params: {
            user_id: user.id
          }
        }.to change(FavoriteSurvey, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end
  describe "いいねの削除" do
    context "ユーザーとアンケートといいねが存在し、いいねを削除すると" do
      it "いいね削除に成功する" do
        favorite_survey = create(:favorite_survey, user_id: user.id, survey_id: survey.id)

        expect {
          delete survey_favorite_survey_path(survey, favorite_survey), params: {
            user_id: user.id
          }
        }.to change(FavoriteSurvey, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end
    context "ログインしていない(current_userがいない)と" do
      it "いいね削除に失敗する" do
        favorite_survey = create(:favorite_survey, user_id: user.id, survey_id: survey.id)
        expect {
          delete survey_favorite_survey_path(survey, favorite_survey), params: {
            user_id: -1
          }
        }.to change(FavoriteSurvey, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "アンケートが存在しないと" do
      it "いいね削除に失敗する" do
        favorite_survey = create(:favorite_survey, user_id: user.id, survey_id: survey.id)
        expect {
          delete survey_favorite_survey_path(-1, favorite_survey), params: {
            user_id: user.id
          }
        }.to change(FavoriteSurvey, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end
    context "ユーザーとアンケートに紐づくいいねが存在しないと" do
      it "いいね削除に失敗する" do
        user2 = create(:user)
        favorite_survey = create(:favorite_survey, user_id: user2.id, survey_id: survey.id)
        expect {
          delete survey_favorite_survey_path(survey, favorite_survey), params: {
            user_id: user.id
          }
        }.to change(FavoriteSurvey, :count).by(0)
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)["error"]).to eq("いいねされていません")
      end
    end
  end


end
