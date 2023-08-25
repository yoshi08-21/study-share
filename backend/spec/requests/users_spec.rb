require 'rails_helper'

RSpec.describe "Users", type: :request do

  let(:user) { create(:user) }

  describe "ユーザー登録" do
    context "正しいパラメーターでユーザー登録すると" do
      it "ユーザー登録に成功する" do
        expect {
          post users_path, params: {
            user: {
              name: "神奈川太郎",
              email: "kanagawa@sample.com",
              uid: "123456"
            }
          }
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to eq("神奈川太郎")
        expect(json_response["email"]).to eq("kanagawa@sample.com")

        user = User.find_by(name: "神奈川太郎")
        expect(user).not_to be_nil
        expect(user.email).to eq("kanagawa@sample.com")
      end
    end
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
    context "ログインしていない状態でマイページにアクセスすると" do
      it "情報の取得に失敗する" do
        get user_path(-1)
        expect(response).to have_http_status(404)
      end
    end
    # context "投稿をしている状態でマイページにアクセスすると" do
    #   it "自分の投稿を取得できる" do

    #   end

    # end
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
