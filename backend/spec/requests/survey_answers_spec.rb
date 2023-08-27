require 'rails_helper'

RSpec.describe "SurveyAnswers", type: :request do

  let(:user) { create(:user) }
  let(:user2) { create(:user, name: "アンケート作成者") }
  let(:survey) { create(:survey, user_id: user2.id) }
  let(:survey_answer) { create(:survey_answer, user_id: user.id, survey_id: survey.id) }

  describe "回答の新規作成" do

    context "他人が作成したアンケートに回答すると" do
      it "アンケートの回答に成功する" do
        survey = create(:survey, status: false , user_id: user2.id)
        expect {
          post survey_survey_answers_path(survey), params: {
            survey_answer: {
              selected_option: 1,
              user_id: user.id,
              survey_id: survey.id
            }
          }
        }.to change(SurveyAnswer, :count).by(1)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["selected_option"]).to eq(1)
      end
    end

    context "締切済みのアンケートに回答すると" do
      it "アンケートの回答に失敗する" do
        survey = create(:survey, status: true , user_id: user2.id)
        expect {
          post survey_survey_answers_path(survey), params: {
            survey_answer: {
              selected_option: 1,
              user_id: user.id,
              survey_id: survey.id
            }
          }
        }.to change(SurveyAnswer, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("アンケートは締め切られています")
      end
    end

    context "自分が作成したアンケートに回答すると" do
      it "アンケートの回答に失敗する" do
        survey = create(:survey, status: false , user_id: user.id)
        expect {
          post survey_survey_answers_path(survey), params: {
            survey_answer: {
              selected_option: 1,
              user_id: user.id,
              survey_id: survey.id
            }
          }
        }.to change(SurveyAnswer, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("自分のアンケートには回答できません")
      end
    end

    context "回答済みのアンケートに回答すると" do
      it "アンケートの回答に失敗する" do
        survey = create(:survey, status: false , user_id: user2.id)
        survey_answer = create(:survey_answer, user_id: user.id, survey_id: survey.id)
        expect {
          post survey_survey_answers_path(survey), params: {
            survey_answer: {
              selected_option: 1,
              user_id: user.id,
              survey_id: survey.id
            }
          }
        }.to change(SurveyAnswer, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("すでに回答済みです")
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "アンケートの回答に失敗する" do
        survey = create(:survey, status: false , user_id: user2.id)
        expect {
          post survey_survey_answers_path(survey), params: {
            survey_answer: {
              selected_option: 1,
              user_id: -1,
              survey_id: survey.id
            }
          }
        }.to change(SurveyAnswer, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

    context "アンケートが存在しないと" do
      it "アンケートの回答に失敗する" do
        survey = create(:survey, status: false , user_id: user2.id)
        expect {
          post survey_survey_answers_path(-1), params: {
            survey_answer: {
              selected_option: 1,
              user_id: user.id,
              survey_id: -1
            }
          }
        }.to change(SurveyAnswer, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "回答の変更" do

    context "すでに選択した回答と異なる回答を選択すると" do
      it "回答が変更される" do
        survey = create(:survey, status: false , user_id: user2.id)
        survey_answer = create(:survey_answer, selected_option: 1, user_id: user.id, survey_id: survey.id)

        expect(survey_answer.selected_option).to eq(1)

        expect {
          patch change_survey_answer_survey_survey_answers_path(survey, survey_answer), params: {
              survey_answer: {
                selected_option: 2,
                user_id: user.id,
                survey_id: survey.id
              }
            }
          }.to change(SurveyAnswer, :count).by(0)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["selected_option"]).to eq(2)
      end
    end

    context "すでに選択した回答と同じ回答を選択すると" do
      it "回答が削除される" do
        survey = create(:survey, status: false , user_id: user2.id)
        survey_answer = create(:survey_answer, selected_option: 1, user_id: user.id, survey_id: survey.id)

        expect {
          patch change_survey_answer_survey_survey_answers_path(survey, survey_answer), params: {
              survey_answer: {
                selected_option: 1,
                user_id: user.id,
                survey_id: survey.id
              }
            }
          }.to change(SurveyAnswer, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

  end

  describe "current_userがアンケートに回答済みかどうかを取得する(check_current_user_answer)" do

    context "current_userがアンケートに回答済みだと" do
      it "アンケートの回答が返ってくる" do
        survey = create(:survey, status: false , user_id: user2.id)
        survey_answer = create(:survey_answer, user_id: user.id, survey_id: survey.id)

        get check_current_user_answer_survey_survey_answers_path(survey), params: {
          user_id: user.id
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["user_id"]).to eq(user.id)
      end
    end

    context "current_userがアンケート未回答だと" do
      it "204が返ってくる" do
        survey = create(:survey, status: false , user_id: user2.id)

        get check_current_user_answer_survey_survey_answers_path(survey), params: {
          user_id: user.id
        }
        expect(response).to have_http_status(204)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "取得に失敗する" do
        survey = create(:survey, status: false , user_id: user2.id)
        survey_answer = create(:survey_answer, user_id: user.id, survey_id: survey.id)

        get check_current_user_answer_survey_survey_answers_path(survey), params: {
          user_id: -1
        }
        expect(response).to have_http_status(404)
      end
    end

    context "アンケートが存在しないと" do
      it "取得に失敗する" do
        survey = create(:survey, status: false , user_id: user2.id)
        survey_answer = create(:survey_answer, user_id: user.id, survey_id: survey.id)

        get check_current_user_answer_survey_survey_answers_path(-1), params: {
          user_id: user.id
        }
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "アンケートに関連する回答の一覧を取得する(get_survey_answers)" do

    context "アンケートに3件の回答が存在すると" do
      it "3件の回答が取得できる" do
        user3 = create(:user)
        user4 = create(:user)
        survey = create(:survey, status: false , user_id: user.id)
        survey_answer = create(:survey_answer, selected_option: 1,user_id: user2.id, survey_id: survey.id)
        survey_answer = create(:survey_answer, selected_option: 2,user_id: user3.id, survey_id: survey.id)
        survey_answer = create(:survey_answer, selected_option: 3,user_id: user4.id, survey_id: survey.id)

        get get_survey_answers_survey_survey_answers_path(survey)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response[0]["user_id"]).to eq(user2.id)
          expect(json_response[0]["selected_option"]).to eq(1)
          expect(json_response[1]["user_id"]).to eq(user3.id)
          expect(json_response[1]["selected_option"]).to eq(2)
          expect(json_response[2]["user_id"]).to eq(user4.id)
          expect(json_response[2]["selected_option"]).to eq(3)
        end
      end
    end

    context "アンケートに回答が存在しないと" do
      it "空の配列が返ってくる" do
        get get_survey_answers_survey_survey_answers_path(survey)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

  end



end
