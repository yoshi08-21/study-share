require 'rails_helper'

RSpec.describe "SubjectQuestionReplies", type: :request do

  let(:user) { create(:user) }
  let(:subject_question) { create(:subject_question, user_id: user.id) }
  let(:subject_question_reply) { create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id) }

  describe "返信の一覧表示" do

    context "質問に3件の返信が投稿されていると" do
      it "3件の質問が表示される" do
        user = create(:user, name: "返信投稿者")
        create(:subject_question_reply, content: "テスト返信本文", user_id: user.id, subject_question_id: subject_question.id)
        create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id)
        create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id)

        get subject_question_subject_question_replies_path(subject_question)
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
        create(:favorite_subject_question_reply, user_id: user.id, subject_question_reply_id: subject_question_reply.id)
        create(:favorite_subject_question_reply, user_id: user2.id, subject_question_reply_id: subject_question_reply.id)

        get subject_question_subject_question_replies_path(subject_question)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)[0]["favorite_subject_question_replies_count"]).to eq(2)
      end
    end

    context "質問に返信が投稿されていないと" do
      it "空の配列が返ってくる" do
        get subject_question_subject_question_replies_path(subject_question)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).length).to eq(0)
      end
    end

    context "質問が存在しないと" do
      it "返信の表示に失敗する" do
        get subject_question_subject_question_replies_path(-1)
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
        subject_question_user = create(:user, name: "質問投稿者")
        subject_question = create(:subject_question, title: "テスト質問タイトル", user_id: subject_question_user.id)
        subject_question_reply = create(:subject_question_reply, content: "テスト返信本文", image: image, subject_question_id: subject_question.id, user_id: user.id)

        get subject_question_subject_question_reply_path(subject_question, subject_question_reply)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question"]["title"]).to eq("テスト質問タイトル")
          expect(json_response["subject_question_user"]["name"]).to eq("質問投稿者")
          expect(json_response["subject_question_reply"]["content"]).to eq("テスト返信本文")
          expect(json_response["subject_question_reply"]["image"]).to include("no_image.png")
          expect(json_response["subject_question_reply_user"]["name"]).to eq("返信投稿者")
        end
      end

      it "返信に関連する質問の情報が表示される" do
        user = create(:user, name: "返信投稿者")
        subject_question_user = create(:user, name: "質問投稿者")
        subject_question = create(:subject_question, title: "テスト質問タイトル", content: "テスト質問本文", subject: "物理", user_id: subject_question_user.id)
        subject_question_reply = create(:subject_question_reply, content: "テスト返信本文", subject_question_id: subject_question.id, user_id: user.id)
        favorite_subject_question = create(:favorite_subject_question, user_id: user.id, subject_question_id: subject_question.id)

        get subject_question_subject_question_reply_path(subject_question, subject_question_reply)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question"]["title"]).to eq("テスト質問タイトル")
          expect(json_response["subject_question"]["content"]).to eq("テスト質問本文")
          expect(json_response["subject_question"]["subject"]).to eq("物理")
          expect(json_response["subject_question"]["favorite_subject_questions_count"]).to eq(1)
          expect(json_response["subject_question"]["subject_question_replies_count"]).to eq(1)
          expect(json_response["subject_question_user"]["name"]).to eq("質問投稿者")
        end
      end
    end

    context "返信にいいねがされていると" do
      it "いいねの件数が表示される" do
        user2 = create(:user)
        create(:favorite_subject_question_reply, user_id: user.id, subject_question_reply_id: subject_question_reply.id)
        create(:favorite_subject_question_reply, user_id: user2.id, subject_question_reply_id: subject_question_reply.id)

        get subject_question_subject_question_reply_path(subject_question, subject_question_reply)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_question_reply"]["favorite_subject_question_replies_count"]).to eq(2)
      end
    end

    context "存在しない返信の詳細ページに遷移すると" do
      it "返信の取得に失敗する" do
        get subject_question_subject_question_reply_path(subject_question, -1)
        expect(response).to have_http_status(404)
      end
    end

    context "質問が存在しないと" do
      it "返信の取得に失敗する" do
        get subject_question_subject_question_reply_path(-1, subject_question_reply)
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "返信の新規投稿" do

    context "正しいパラメーターで返信を投稿すると" do
      it "返信の投稿に成功する" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')
        subject_question = create(:subject_question, user_id: user.id)

        expect {
          post subject_question_subject_question_replies_path(subject_question), params: {
            subject_question_reply: {
              content: "テスト返信本文",
              image: image,
              subject_question_id: subject_question.id
            },
            current_user_id: user.id,
          }
        }.to change(SubjectQuestionReply, :count).by(1)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        expect(json_response["content"]).to eq("テスト返信本文")

        get subject_question_subject_question_reply_path(subject_question, json_response["id"])
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["subject_question_reply"]["image"]).to include("no_image.png")
      end
    end

    context "不正なパラメーターで返信を投稿すると" do
      it "返信の投稿に失敗する" do
        expect {
          post subject_question_subject_question_replies_path(subject_question), params: {
            subject_question_reply: {
              content: "",
              subject_question_id: subject_question.id
            },
            current_user_id: user.id,
          }
        }.to change(SubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "返信の投稿に失敗する" do
        expect {
          post subject_question_subject_question_replies_path(subject_question), params: {
            subject_question_reply: {
              content: "テスト返信本文",
              subject_question_id: subject_question.id
            },
            current_user_id: -1,
          }
        }.to change(SubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

    context "質問が存在しないと" do
      it "返信の投稿に失敗する" do
        expect {
          post subject_question_subject_question_replies_path(-1), params: {
            subject_question_reply: {
              content: "テスト返信本文",
              subject_question_id: -1
            },
            current_user_id: user.id,
          }
        }.to change(SubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "返信の編集" do

    context "正しいパラメーターで返信を編集すると" do
      it "返信の編集に成功する" do
        image_path = Rails.root.join("spec", "fixtures", "files", "no_image.png")
        image = fixture_file_upload(image_path, 'image/png')
        subject_question = create(:subject_question, user_id: user.id)
        subject_question_reply = create(:subject_question_reply, content: "テスト返信本文", user_id: user.id, subject_question_id: subject_question.id)

        expect(subject_question_reply.content).to eq("テスト返信本文")

        patch subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
          subject_question_reply: {
            content: "変更後テスト返信本文",
            image: image,
          },
          current_user_id: user.id,
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question_reply"]["content"]).to eq("変更後テスト返信本文")
          expect(json_response["image_url"]).to include("no_image.png")
        end
      end
    end

    context "不正なパラメーターで返信を編集すると" do
      it "返信の編集に失敗する" do
        subject_question = create(:subject_question, user_id: user.id)
        subject_question_reply = create(:subject_question_reply, content: "テスト返信本文", user_id: user.id, subject_question_id: subject_question.id)

        patch subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
          subject_question_reply: {
            content: "",
          },
          current_user_id: user.id,
        }
        expect(response).to have_http_status(422)
      end
    end

    context "他人が投稿した返信を編集すると" do
      it "返信の編集に失敗する" do
        user2 = create(:user)
        subject_question = create(:subject_question, user_id: user.id)
        subject_question_reply = create(:subject_question_reply, content: "テスト返信本文", user_id: user.id, subject_question_id: subject_question.id)

        patch subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
          subject_question_reply: {
            content: "変更後テスト返信本文",
          },
          current_user_id: user2.id,
        }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "返信の編集に失敗する" do
        patch subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
          subject_question_reply: {
            content: "テスト返信本文",
            subject_question_id: subject_question.id
          },
          current_user_id: -1,
        }
        expect(response).to have_http_status(404)
      end
    end

    context "返信が存在しないと" do
      it "返信の編集に失敗する" do
        patch subject_question_subject_question_reply_path(subject_question, -1), params: {
          subject_question_reply: {
            content: "テスト返信本文",
            subject_question_id: subject_question.id
          },
          current_user_id: user.id,
        }
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "返信の削除" do

    context "自分が作成した返信を削除すると" do
      it "返信の削除に成功する" do
        subject_question_reply = create(:subject_question_reply, content: "テスト返信本文", user_id: user.id, subject_question_id: subject_question.id)
        expect {
          delete subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
            current_user_id: user.id
          }
        }.to change(SubjectQuestionReply, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

    context "他人が作成した返信を削除すると" do
      it "返信の削除に失敗する" do
        user2 = create(:user)
        subject_question_reply = create(:subject_question_reply, content: "テスト返信本文", user_id: user.id, subject_question_id: subject_question.id)
        expect {
          delete subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
            current_user_id: user2.id
          }
        }.to change(SubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("権限がありません")
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "返信の削除に失敗する" do
        user = create(:user)
        subject_question = create(:subject_question, user_id: user.id)
        subject_question_reply = create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id)
        expect {
          delete subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
            current_user_id: -1
          }
        }.to change(SubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

    context "返信が存在しないと" do
      it "返信の削除に失敗する" do
        user = create(:user)
        subject_question = create(:subject_question, user_id: user.id)
        subject_question_reply = create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id)
        expect {
          delete subject_question_subject_question_reply_path(subject_question, -1), params: {
            current_user_id: user.id
          }
        }.to change(SubjectQuestionReply, :count).by(0)
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "返信情報の取得" do

    context "check_existenceで存在する返信をチェックすると" do
      it "成功する" do
        get check_existence_subject_question_replies_path, params: {
          subject_question_id: subject_question.id,
          id: subject_question_reply.id
        }
        expect(response).to have_http_status(200)
      end
    end

    context "check_existenceで存在しない返信をチェックすると" do
      it "失敗する" do
        get check_existence_subject_question_replies_path, params: {
          subject_question_id: subject_question.id,
          id: -1
        }
        expect(response).to have_http_status(404)
      end
    end
  end



end
