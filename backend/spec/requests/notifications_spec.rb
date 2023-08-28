require 'rails_helper'

RSpec.describe "Notifications", type: :request do

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


  describe "レビューのお気に入り通知" do

    context "自分が投稿したレビューがいいねされると" do
      it "通知が作成される" do
        expect {
          post review_favorite_reviews_path(review), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["review_id"]).to eq(review.id)
          expect(json_response[0]["action_type"]).to eq("Favorite")
          expect(json_response[0]["action_to"]).to eq("Review")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "action_userからのレビューのいいね通知がすでに存在すると" do
      it "通知が作成されない" do
        create(:notification, action_user_id: user2.id, target_user_id: user.id, review_id: review.id, action_type: "Favorite", action_to: "Review")

        expect {
          post review_favorite_reviews_path(review), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(0)
      end
    end

    context "レビューのいいねが削除されると" do
      it "通知が削除される" do
        favorite_review = create(:favorite_review, user_id: user2.id, review_id: review.id)
        create(:notification, action_user_id: user2.id, target_user_id: user.id, review_id: review.id, action_type: "Favorite", action_to: "Review")

        expect {
          delete review_favorite_review_path(review, favorite_review), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(-1)
      end
    end

  end


  describe "質問のお気に入り通知" do

    context "自分が投稿した質問がいいねされると" do
      it "通知が作成される" do
        expect {
          post question_favorite_questions_path(question), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["question_id"]).to eq(question.id)
          expect(json_response[0]["action_type"]).to eq("Favorite")
          expect(json_response[0]["action_to"]).to eq("Question")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "action_userからの質問のいいね通知がすでに存在すると" do
      it "通知が作成されない" do
        create(:notification, action_user_id: user2.id, target_user_id: user.id, question_id: question.id, action_type: "Favorite", action_to: "Question")

        expect {
          post question_favorite_questions_path(question), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(0)
      end
    end

    context "質問のいいねが削除されると" do
      it "通知が削除される" do
        favorite_question = create(:favorite_question, user_id: user2.id, question_id: question.id)
        create(:notification, action_user_id: user2.id, target_user_id: user.id, question_id: question.id, action_type: "Favorite", action_to: "Question")

        expect {
          delete question_favorite_question_path(question, favorite_question), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(-1)
      end
    end

  end

  describe "返信のお気に入り通知" do

    context "自分が投稿した返信がいいねされると" do
      it "通知が作成される" do
        expect {
          post reply_favorite_replies_path(reply), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["reply_id"]).to eq(reply.id)
          expect(json_response[0]["action_type"]).to eq("Favorite")
          expect(json_response[0]["action_to"]).to eq("Reply")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "action_userからの返信のいいね通知がすでに存在すると" do
      it "通知が作成されない" do
        create(:notification, action_user_id: user2.id, target_user_id: user.id, reply_id: reply.id, action_type: "Favorite", action_to: "Reply")

        expect {
          post reply_favorite_replies_path(reply), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(0)
      end
    end

    context "返信のいいねが削除されると" do
      it "通知が削除される" do
        favorite_reply = create(:favorite_reply, user_id: user2.id, reply_id: reply.id)
        create(:notification, action_user_id: user2.id, target_user_id: user.id, reply_id: reply.id, action_type: "Favorite", action_to: "Reply")

        expect {
          delete reply_favorite_reply_path(reply, favorite_reply), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(-1)
      end
    end

  end

  describe "質問(科目別)のお気に入り通知" do

    context "自分が投稿した質問(科目別)がいいねされると" do
      it "通知が作成される" do
        expect {
          post subject_question_favorite_subject_questions_path(subject_question), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["subject_question_id"]).to eq(subject_question.id)
          expect(json_response[0]["action_type"]).to eq("Favorite")
          expect(json_response[0]["action_to"]).to eq("SubjectQuestion")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "action_userからの質問(科目別)のいいね通知がすでに存在すると" do
      it "通知が作成されない" do
        create(:notification, action_user_id: user2.id, target_user_id: user.id, subject_question_id: subject_question.id, action_type: "Favorite", action_to: "SubjectQuestion")

        expect {
          post subject_question_favorite_subject_questions_path(subject_question), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(0)
      end
    end

    context "質問(科目別)のいいねが削除されると" do
      it "通知が削除される" do
        favorite_subject_question = create(:favorite_subject_question, user_id: user2.id, subject_question_id: subject_question.id)
        create(:notification, action_user_id: user2.id, target_user_id: user.id, subject_question_id: subject_question.id, action_type: "Favorite", action_to: "SubjectQuestion")

        expect {
          delete subject_question_favorite_subject_question_path(subject_question, favorite_subject_question), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(-1)
      end
    end

  end

  describe "返信(科目別)のお気に入り通知" do

    context "自分が投稿した返信(科目別)がいいねされると" do
      it "通知が作成される" do
        expect {
          post subject_question_reply_favorite_subject_question_replies_path(subject_question_reply), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["subject_question_reply_id"]).to eq(subject_question_reply.id)
          expect(json_response[0]["action_type"]).to eq("Favorite")
          expect(json_response[0]["action_to"]).to eq("SubjectQuestionReply")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "action_userからの返信(科目別)のいいね通知がすでに存在すると" do
      it "通知が作成されない" do
        create(:notification, action_user_id: user2.id, target_user_id: user.id, subject_question_reply_id: subject_question_reply.id, action_type: "Favorite", action_to: "SubjectQuestionReply")

        expect {
          post subject_question_reply_favorite_subject_question_replies_path(subject_question_reply), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(0)
      end
    end

    context "返信(科目別)のいいねが削除されると" do
      it "通知が削除される" do
        favorite_subject_question_reply = create(:favorite_subject_question_reply, user_id: user2.id, subject_question_reply_id: subject_question_reply.id)
        create(:notification, action_user_id: user2.id, target_user_id: user.id, subject_question_reply_id: subject_question_reply.id, action_type: "Favorite", action_to: "SubjectQuestionReply")

        expect {
          delete subject_question_reply_favorite_subject_question_reply_path(subject_question_reply, favorite_subject_question_reply), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(-1)
      end
    end

  end

  describe "アンケートのお気に入り通知" do

    context "自分が作成したアンケートがいいねされると" do
      it "通知が作成される" do
        expect {
          post survey_favorite_surveys_path(survey), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["survey_id"]).to eq(survey.id)
          expect(json_response[0]["action_type"]).to eq("Favorite")
          expect(json_response[0]["action_to"]).to eq("Survey")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "action_userからのアンケートのいいね通知がすでに存在すると" do
      it "通知が作成されない" do
        create(:notification, action_user_id: user2.id, target_user_id: user.id, survey_id: survey.id, action_type: "Favorite", action_to: "Survey")

        expect {
          post survey_favorite_surveys_path(survey), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(0)
      end
    end

    context "アンケートのいいねが削除されると" do
      it "通知が削除される" do
        favorite_survey = create(:favorite_survey, user_id: user2.id, survey_id: survey.id)
        create(:notification, action_user_id: user2.id, target_user_id: user.id, survey_id: survey.id, action_type: "Favorite", action_to: "Survey")

        expect {
          delete survey_favorite_survey_path(survey, favorite_survey), params: {
            user_id: user2.id
          }
        }.to change(Notification, :count).by(-1)
      end
    end

  end

  describe "質問への返信通知" do

    context "自分の質問に返信が投稿されると" do
      it "自分への通知が作成される" do
        question = create(:question, user_id: user.id, book_id: book.id)

        expect {
          post book_question_replies_path(book, question), params: {
            reply: {
              content: "テスト返信本文",
              user_id: user2.id,
              question_id: question.id
            }
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)
        response_reply_id = JSON.parse(response.body)["id"]

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["question_id"]).to eq(question.id)
          expect(json_response[0]["reply_id"]).to eq(response_reply_id)
          expect(json_response[0]["action_type"]).to eq("Reply")
          expect(json_response[0]["action_to"]).to eq("Reply")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "自分が'返信を投稿した質問'に返信が投稿されると" do
      it "自分と質問の投稿者に通知が作成される" do
        user3 = create(:user)
        question = create(:question, user_id: user2.id, book_id: book.id)
        create(:reply, user_id: user.id, question_id: question.id)

        expect {
          post book_question_replies_path(book, question), params: {
            reply: {
              content: "テスト返信本文",
              user_id: user3.id,
              question_id: question.id
            }
          }
        }.to change(Notification, :count).by(2)
        expect(response).to have_http_status(200)
        response_reply_id = JSON.parse(response.body)["id"]

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user3.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["question_id"]).to eq(question.id)
          expect(json_response[0]["reply_id"]).to eq(response_reply_id)
          expect(json_response[0]["action_type"]).to eq("Reply")
          expect(json_response[0]["action_to"]).to eq("Reply")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "自分の質問に返信を投稿した状態で、他人が自分の質問に返信を投稿すると" do
      it "自分に質問の投稿者宛の通知だけが作成される" do
        question = create(:question, user_id: user.id, book_id: book.id)
        create(:reply, user_id: user.id, question_id: question.id)

        expect {
          post book_question_replies_path(book, question), params: {
            reply: {
              content: "テスト返信本文",
              user_id: user2.id,
              question_id: question.id
            }
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end

    context "自分の質問に返信を投稿すると" do
      it "通知が作成されない" do
        question = create(:question, user_id: user.id, book_id: book.id)

        expect {
          post book_question_replies_path(book, question), params: {
            reply: {
              content: "テスト返信本文",
              user_id: user.id,
              question_id: question.id
            }
          }
        }.to change(Notification, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "質問(科目別)への返信通知" do

    context "自分の質問(科目別)に返信が投稿されると" do
      it "自分への通知が作成される" do
        subject_question = create(:subject_question, user_id: user.id)

        expect {
          post subject_question_subject_question_replies_path(subject_question), params: {
            subject_question_reply: {
              content: "テスト返信本文",
              user_id: user2.id,
              subject_question_id: subject_question.id
            }
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)
        response_subject_question_reply_id = JSON.parse(response.body)["id"]

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["subject_question_id"]).to eq(subject_question.id)
          expect(json_response[0]["subject_question_reply_id"]).to eq(response_subject_question_reply_id)
          expect(json_response[0]["action_type"]).to eq("Reply")
          expect(json_response[0]["action_to"]).to eq("SubjectQuestionReply")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "自分が'返信を投稿した質問(科目別)'に返信が投稿されると" do
      it "自分と質問の投稿者に通知が作成される" do
        user3 = create(:user)
        subject_question = create(:subject_question, user_id: user2.id)
        create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id)

        expect {
          post subject_question_subject_question_replies_path(subject_question), params: {
            subject_question_reply: {
              content: "テスト返信本文",
              user_id: user3.id,
              subject_question_id: subject_question.id
            }
          }
        }.to change(Notification, :count).by(2)
        expect(response).to have_http_status(200)
        response_subject_question_reply_id = JSON.parse(response.body)["id"]

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user3.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["subject_question_id"]).to eq(subject_question.id)
          expect(json_response[0]["subject_question_reply_id"]).to eq(response_subject_question_reply_id)
          expect(json_response[0]["action_type"]).to eq("Reply")
          expect(json_response[0]["action_to"]).to eq("SubjectQuestionReply")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "自分の質問(科目別)に返信を投稿した状態で、他人が自分の質問(科目別)に返信を投稿すると" do
      it "自分に質問の投稿者宛の通知だけが作成される" do
        subject_question = create(:subject_question, user_id: user.id)
        create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id)

        expect {
          post subject_question_subject_question_replies_path(subject_question), params: {
            subject_question_reply: {
              content: "テスト返信本文",
              user_id: user2.id,
              subject_question_id: subject_question.id
            }
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end

    context "自分の質問(科目別)に返信を投稿すると" do
      it "通知が作成されない" do
        subject_question = create(:subject_question, user_id: user.id)

        expect {
          post subject_question_subject_question_replies_path(subject_question), params: {
            subject_question_reply: {
              content: "テスト返信本文",
              user_id: user.id,
              subject_question_id: subject_question.id
            }
          }
        }.to change(Notification, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "アンケートへの回答通知" do

    context "自分が作成したアンケートに回答が投稿されると" do
      it "自分への通知が作成される" do
        survey = create(:survey, user_id: user.id)

        expect {
          post survey_survey_answers_path(survey), params: {
            survey_answer: {
              selected_option: 1,
              user_id: user2.id,
              survey_id: survey.id
            }
          }
        }.to change(Notification, :count).by(1)
        expect(response).to have_http_status(200)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["survey_id"]).to eq(survey.id)
          expect(json_response[0]["action_type"]).to eq("SurveyAnswer")
          expect(json_response[0]["action_to"]).to eq("SurveyAnswer")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "自分が作成したアンケートに投稿された回答が削除されると" do
      it "自分への通知が削除される" do
        survey = create(:survey, user_id: user.id)
        survey_answer = create(:survey_answer, selected_option: 1, user_id: user2.id, survey_id: survey.id)
        create(:notification, action_user_id: user2.id, target_user_id: user.id, survey_id: survey.id, action_type: "SurveyAnswer", action_to: "SurveyAnswer")

        expect {
          patch change_survey_answer_survey_survey_answers_path(survey, survey_answer), params: {
            survey_answer: {
              selected_option: 1,
              user_id: user2.id,
              survey_id: survey.id
            }
          }
        }.to change(Notification, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

  end

  describe "100件を超えた通知の自動削除" do
    context "通知が100件を超えた状態で通知一覧ページに遷移すると" do
      it "通知の件数が100件になるまで古い通知から順に削除される" do
        create_list(:notification, 101, action_user_id: user2.id, target_user_id: user.id, question_id: question.id, reply_id: reply.id)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(101)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(100)
      end
    end

  end

  describe "新着通知の確認(check_unread_notifications)" do

    context "新着通知が存在すると" do
      it "200が返ってくる" do
        create(:notification, action_user_id: user2.id, target_user_id: user.id, survey_id: survey.id, action_type: "SurveyAnswer", action_to: "SurveyAnswer", is_checked: false)

        get check_unread_notifications_notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)
      end
    end

    context "新着通知が存在しないと" do
      it "204が返ってくる" do
        create(:notification, action_user_id: user2.id, target_user_id: user.id, survey_id: survey.id, action_type: "SurveyAnswer", action_to: "SurveyAnswer", is_checked: true)

        get check_unread_notifications_notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(204)

      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "204が返ってくる" do
        create(:notification, action_user_id: user2.id, target_user_id: user.id, survey_id: survey.id, action_type: "SurveyAnswer", action_to: "SurveyAnswer", is_checked: false)

        get check_unread_notifications_notifications_path, params: {
          current_user_id: -1
        }
        expect(response).to have_http_status(204)
      end
    end

  end

  describe "通知サンプルの作成" do

    context "科目別質問を投稿していると" do
      it "自分の科目別質問に返信が投稿され、通知が作成される" do
        subject_question = create(:subject_question, user_id: user.id)

        expect {
          post create_sample_notification_subject_question_replies_path, params: {
            current_user_id: user.id,
            sample_user_id: user2.id
          }
        }.to change(Notification, :count).by(1)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["subject_question_id"]).to eq(subject_question.id)
          expect(json_response[0]["action_type"]).to eq("Reply")
          expect(json_response[0]["action_to"]).to eq("SubjectQuestionReply")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "科目別質問を投稿してないと" do
      it "自分の科目別質問が作成され、その質問に投稿が返信され、通知が作成される" do
        subject_question = create(:subject_question, user_id: user2.id)

        expect {
          post create_sample_notification_subject_question_replies_path, params: {
            current_user_id: user.id,
            sample_user_id: user2.id
          }
        }.to change(Notification, :count).by(1)
          .and change(SubjectQuestion, :count).by(1)

        get notifications_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response.length).to eq(1)
          expect(json_response[0]["action_user_id"]).to eq(user2.id)
          expect(json_response[0]["target_user_id"]).to eq(user.id)
          expect(json_response[0]["action_type"]).to eq("Reply")
          expect(json_response[0]["action_to"]).to eq("SubjectQuestionReply")
          expect(json_response[0]["is_checked"]).to eq(false)
        end
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "通知サンプルの作成に失敗する" do
        subject_question = create(:subject_question, user_id: user.id)

        expect {
          post create_sample_notification_subject_question_replies_path, params: {
            current_user_id: -1,
            sample_user_id: user2.id
          }
        }.to change(Notification, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

    context "通知サンプル作成用のサンプルユーザーが存在しないと" do
      it "通知サンプルの作成に失敗する" do
        subject_question = create(:subject_question, user_id: user.id)

        expect {
          post create_sample_notification_subject_question_replies_path, params: {
            current_user_id: user.id,
            sample_user_id: -1
          }
        }.to change(Notification, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

  end




end
