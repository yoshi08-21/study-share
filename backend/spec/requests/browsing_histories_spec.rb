require 'rails_helper'

RSpec.describe "BrowsingHistories", type: :request do

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


  describe "参考書の閲覧履歴" do

    context "ログインしている状態で参考書の詳細を閲覧すると" do
      it "参考書の閲覧履歴が作成される" do
        book = create(:book, name: "サンプル参考書", author: "サンプル著者", publisher: "サンプル出版社", subject: "古文", user_id: user.id)
        create(:review, rating: 5, user_id: user.id, book_id: book.id)
        create(:review, rating: 1, user_id: user.id, book_id: book.id)
        create(:favorite_book, user_id: user.id, book_id: book.id)

        expect {
          get book_path(book), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(1)
        expect(response).to have_http_status(200)

        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["book_browsing_histories"].length).to eq(1)
          expect(json_response["book_browsing_histories"][0]["name"]).to eq("サンプル参考書")
          expect(json_response["book_browsing_histories"][0]["author"]).to eq("サンプル著者")
          expect(json_response["book_browsing_histories"][0]["publisher"]).to eq("サンプル出版社")
          expect(json_response["book_browsing_histories"][0]["subject"]).to eq("古文")
          expect(json_response["book_browsing_histories"][0]["check_favorite"]).to eq(1)
          expect(json_response["book_browsing_histories"][0]["reviews_count"]).to eq(2)
          expect(json_response["book_browsing_histories"][0]["average_rating"]).to eq("3.0")
          expect(json_response["book_browsing_histories"][0]["favorite_books_count"]).to eq(1)
        end
      end
    end

    context "ログインしている & 参考書の閲覧履歴が10件存在していると" do
      it "一番古い閲覧履歴が削除された後、参考書の閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        books = create_list(:book, 10, user_id: user.id) do |book, i|
          book.name = "参考書#{i + 1}"
          book.save
        end

        books.each do |book|
          create(:browsing_history, user_id: user.id, book_id: book.id)
        end
        book11 = create(:book, name: "参考書11", user_id: user.id)

        # 　閲覧履歴の確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["book_browsing_histories"].length).to eq(10)
          expect(json_response["book_browsing_histories"][0]["name"]).to eq("参考書1")
          expect(json_response["book_browsing_histories"][9]["name"]).to eq("参考書10")
        end

        # 閲覧履歴の作成
        get book_path(book11), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        # 閲覧履歴の再確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["book_browsing_histories"].length).to eq(10)
          expect(json_response["book_browsing_histories"][0]["name"]).to eq("参考書2")
          expect(json_response["book_browsing_histories"][9]["name"]).to eq("参考書11")
        end
      end
    end

    context "対象の参考書の閲覧履歴がすでに存在すると" do
      it "参考書の閲覧履歴が作成されない" do
        book = create(:book, name: "サンプル参考書", author: "サンプル著者", publisher: "サンプル出版社", subject: "古文", user_id: user.id)
        create(:browsing_history, user_id: user.id, book_id: book.id)

        expect {
          get book_path(book), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "参考書の閲覧履歴が作成されない" do
        book = create(:book, name: "サンプル参考書", author: "サンプル著者", publisher: "サンプル出版社", subject: "古文", user_id: user.id)

        expect {
          get book_path(book), params: {
            current_user_id: -1
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)

      end
    end


  end

  describe "レビューの閲覧履歴" do

    context "ログインしている状態でレビューの詳細を閲覧すると" do
      it "レビューの閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        book = create(:book, name: "サンプル参考書", author: "サンプル著者", publisher: "サンプル出版社", subject: "古文", user_id: user.id)
        review = create(:review, title: "サンプルレビュータイトル", content: "サンプルレビュー本文", rating: 5, user_id: user.id, book_id: book.id)
        create(:favorite_review, user_id: user2.id, review_id: review.id)

        expect {
          get book_review_path(book, review), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(1)
        expect(response).to have_http_status(200)

        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["review_browsing_histories"].length).to eq(1)
          expect(json_response["review_browsing_histories"][0]["user"]["name"]).to eq("東京太郎")
          expect(json_response["review_browsing_histories"][0]["book"]["name"]).to eq("サンプル参考書")
          expect(json_response["review_browsing_histories"][0]["title"]).to eq("サンプルレビュータイトル")
          expect(json_response["review_browsing_histories"][0]["content"]).to eq("サンプルレビュー本文")
          expect(json_response["review_browsing_histories"][0]["rating"]).to eq(5)
          expect(json_response["review_browsing_histories"][0]["favorite_reviews_count"]).to eq(1)
        end
      end
    end

    context "ログインしている & レビューの閲覧履歴が10件存在していると" do
      it "一番古い閲覧履歴が削除された後、レビューの閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        reviews = create_list(:review, 10, user_id: user.id, book_id: book.id) do |review, i|
          review.title = "レビュータイトル#{i + 1}"
          review.save
        end

        reviews.each do |review|
          create(:browsing_history, user_id: user.id, review_id: review.id)
        end
        review11 = create(:review, title: "レビュータイトル11", user_id: user.id, book_id: book.id)

        # 　閲覧履歴の確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["review_browsing_histories"].length).to eq(10)
          expect(json_response["review_browsing_histories"][0]["title"]).to eq("レビュータイトル1")
          expect(json_response["review_browsing_histories"][9]["title"]).to eq("レビュータイトル10")
        end

        # 閲覧履歴の作成
        get book_review_path(book, review11), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        # 閲覧履歴の再確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["review_browsing_histories"].length).to eq(10)
          expect(json_response["review_browsing_histories"][0]["title"]).to eq("レビュータイトル2")
          expect(json_response["review_browsing_histories"][9]["title"]).to eq("レビュータイトル11")
        end
      end
    end

    context "対象のレビューの閲覧履歴がすでに存在すると" do
      it "レビューの閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        book = create(:book, name: "サンプル参考書", author: "サンプル著者", publisher: "サンプル出版社", subject: "古文", user_id: user.id)
        review = create(:review, title: "サンプルレビュータイトル", content: "サンプルレビュー本文", rating: 5, user_id: user.id, book_id: book.id)
        create(:browsing_history, user_id: user.id, review_id: review.id)

        expect {
          get book_review_path(book, review), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "レビューの閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        book = create(:book, name: "サンプル参考書", author: "サンプル著者", publisher: "サンプル出版社", subject: "古文", user_id: user.id)
        review = create(:review, title: "サンプルレビュータイトル", content: "サンプルレビュー本文", rating: 5, user_id: user.id, book_id: book.id)

        expect {
          get book_review_path(book, review), params: {
            current_user_id: -1
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end


  end

  describe "質問の閲覧履歴" do

    context "ログインしている状態で質問の詳細を閲覧すると" do
      it "質問の閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        book = create(:book, name: "サンプル参考書", author: "サンプル著者", publisher: "サンプル出版社", subject: "古文", user_id: user.id)
        question = create(:question, title: "サンプル質問タイトル", content: "サンプル質問本文", user_id: user.id, book_id: book.id)
        create(:reply, user_id: user.id, question_id: question.id)
        create(:favorite_question, user_id: user2.id, question_id: question.id)

        expect {
          get book_question_path(book, question), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(1)
        expect(response).to have_http_status(200)

        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["question_browsing_histories"].length).to eq(1)
          expect(json_response["question_browsing_histories"][0]["user"]["name"]).to eq("東京太郎")
          expect(json_response["question_browsing_histories"][0]["book"]["name"]).to eq("サンプル参考書")
          expect(json_response["question_browsing_histories"][0]["title"]).to eq("サンプル質問タイトル")
          expect(json_response["question_browsing_histories"][0]["content"]).to eq("サンプル質問本文")
          expect(json_response["question_browsing_histories"][0]["replies_count"]).to eq(1)
          expect(json_response["question_browsing_histories"][0]["favorite_questions_count"]).to eq(1)
        end
      end
    end

    context "ログインしている & 質問の閲覧履歴が10件存在していると" do
      it "一番古い閲覧履歴が削除された後、質問の閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        questions = create_list(:question, 10, user_id: user.id, book_id: book.id) do |question, i|
          question.title = "質問タイトル#{i + 1}"
          question.save
        end

        questions.each do |question|
          create(:browsing_history, user_id: user.id, question_id: question.id)
        end
        question11 = create(:question, title: "質問タイトル11", user_id: user.id, book_id: book.id)

        # 　閲覧履歴の確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["question_browsing_histories"].length).to eq(10)
          expect(json_response["question_browsing_histories"][0]["title"]).to eq("質問タイトル1")
          expect(json_response["question_browsing_histories"][9]["title"]).to eq("質問タイトル10")
        end

        # 閲覧履歴の作成
        get book_question_path(book, question11), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        # 閲覧履歴の再確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["question_browsing_histories"].length).to eq(10)
          expect(json_response["question_browsing_histories"][0]["title"]).to eq("質問タイトル2")
          expect(json_response["question_browsing_histories"][9]["title"]).to eq("質問タイトル11")
        end
      end
    end

    context "対象の質問の閲覧履歴がすでに存在すると" do
      it "質問の閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        book = create(:book, name: "サンプル参考書", author: "サンプル著者", publisher: "サンプル出版社", subject: "古文", user_id: user.id)
        question = create(:question, title: "サンプル質問タイトル", content: "サンプル質問本文", user_id: user.id, book_id: book.id)
        create(:browsing_history, user_id: user.id, question_id: question.id)

        expect {
          get book_question_path(book, question), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "質問の閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        book = create(:book, name: "サンプル参考書", author: "サンプル著者", publisher: "サンプル出版社", subject: "古文", user_id: user.id)
        question = create(:question, title: "サンプル質問タイトル", content: "サンプル質問本文", user_id: user.id, book_id: book.id)

        expect {
          get book_question_path(book, question), params: {
            current_user_id: -1
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)

      end
    end

  end

  describe "返信の閲覧履歴" do

    context "ログインしている状態で返信の詳細を閲覧すると" do
      it "返信の閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        reply = create(:reply, content: "サンプル返信本文", user_id: user.id, question_id: question.id)
        create(:favorite_reply, user_id: user2.id, reply_id: reply.id)

        expect {
          get book_question_reply_path(book, question, reply), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(1)
        expect(response).to have_http_status(200)

        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["reply_browsing_histories"].length).to eq(1)
          expect(json_response["reply_browsing_histories"][0]["user"]["name"]).to eq("東京太郎")
          expect(json_response["reply_browsing_histories"][0]["content"]).to eq("サンプル返信本文")
          expect(json_response["reply_browsing_histories"][0]["favorite_replies_count"]).to eq(1)
        end
      end
    end

    context "ログインしている & 返信の閲覧履歴が10件存在していると" do
      it "一番古い閲覧履歴が削除された後、返信の閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        replies = create_list(:reply, 10, user_id: user.id, question_id: question.id) do |reply, i|
          reply.content = "返信本文#{i + 1}"
          reply.save
        end

        replies.each do |reply|
          create(:browsing_history, user_id: user.id, reply_id: reply.id)
        end
        reply11 = create(:reply, content: "返信本文11", user_id: user.id, question_id: question.id)

        # 　閲覧履歴の確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["reply_browsing_histories"].length).to eq(10)
          expect(json_response["reply_browsing_histories"][0]["content"]).to eq("返信本文1")
          expect(json_response["reply_browsing_histories"][9]["content"]).to eq("返信本文10")
        end

        # 閲覧履歴の作成
        get book_question_reply_path(book, question, reply11), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        # 閲覧履歴の再確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["reply_browsing_histories"].length).to eq(10)
          expect(json_response["reply_browsing_histories"][0]["content"]).to eq("返信本文2")
          expect(json_response["reply_browsing_histories"][9]["content"]).to eq("返信本文11")
        end
      end
    end

    context "対象の返信の閲覧履歴がすでに存在すると" do
      it "返信の閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        reply = create(:reply, content: "サンプル返信本文", user_id: user.id, question_id: question.id)
        create(:browsing_history, user_id: user.id, reply_id: reply.id)

        expect {
          get book_question_reply_path(book, question, reply), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "返信の閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        reply = create(:reply, content: "サンプル返信本文", user_id: user.id, question_id: question.id)

        expect {
          get book_question_reply_path(book, question, reply), params: {
            current_user_id: -1
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)

      end
    end

  end

  describe "質問(科目別)の閲覧履歴" do

    context "ログインしている状態で質問(科目別)の詳細を閲覧すると" do
      it "質問(科目別)の閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        subject_question = create(:subject_question, title: "サンプル質問(科目別)タイトル", content: "サンプル質問(科目別)本文", subject: "リスニング", user_id: user.id)
        create(:subject_question_reply, user_id: user.id, subject_question_id: subject_question.id)
        create(:favorite_subject_question, user_id: user2.id, subject_question_id: subject_question.id)

        expect {
          get subject_question_path(subject_question), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(1)
        expect(response).to have_http_status(200)

        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question_browsing_histories"].length).to eq(1)
          expect(json_response["subject_question_browsing_histories"][0]["user"]["name"]).to eq("東京太郎")
          expect(json_response["subject_question_browsing_histories"][0]["title"]).to eq("サンプル質問(科目別)タイトル")
          expect(json_response["subject_question_browsing_histories"][0]["content"]).to eq("サンプル質問(科目別)本文")
          expect(json_response["subject_question_browsing_histories"][0]["subject"]).to eq("リスニング")
          expect(json_response["subject_question_browsing_histories"][0]["subject_question_replies_count"]).to eq(1)
          expect(json_response["subject_question_browsing_histories"][0]["favorite_subject_questions_count"]).to eq(1)
        end
      end
    end

    context "ログインしている & 質問(科目別)の閲覧履歴が10件存在していると" do
      it "一番古い閲覧履歴が削除された後、質問(科目別)の閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        subject_questions = create_list(:subject_question, 10, user_id: user.id) do |subject_question, i|
          subject_question.title = "質問(科目別)タイトル#{i + 1}"
          subject_question.save
        end

        subject_questions.each do |subject_question|
          create(:browsing_history, user_id: user.id, subject_question_id: subject_question.id)
        end
        subject_question11 = create(:subject_question, title: "質問(科目別)タイトル11", user_id: user.id)

        # 　閲覧履歴の確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question_browsing_histories"].length).to eq(10)
          expect(json_response["subject_question_browsing_histories"][0]["title"]).to eq("質問(科目別)タイトル1")
          expect(json_response["subject_question_browsing_histories"][9]["title"]).to eq("質問(科目別)タイトル10")
        end

        # 閲覧履歴の作成
        get subject_question_path(subject_question11), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        # 閲覧履歴の再確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question_browsing_histories"].length).to eq(10)
          expect(json_response["subject_question_browsing_histories"][0]["title"]).to eq("質問(科目別)タイトル2")
          expect(json_response["subject_question_browsing_histories"][9]["title"]).to eq("質問(科目別)タイトル11")
        end
      end
    end

    context "対象の質問(科目別)の閲覧履歴がすでに存在すると" do
      it "質問(科目別)の閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        subject_question = create(:subject_question, title: "サンプル質問(科目別)タイトル", content: "サンプル質問(科目別)本文", subject: "リスニング", user_id: user.id)
        create(:browsing_history, user_id: user.id, subject_question_id: subject_question.id)

        expect {
          get subject_question_path(subject_question), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "質問(科目別)の閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        subject_question = create(:subject_question, title: "サンプル質問(科目別)タイトル", content: "サンプル質問(科目別)本文", subject: "リスニング", user_id: user.id)

        expect {
          get subject_question_path(subject_question), params: {
            current_user_id: -1
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "返信(科目別)の閲覧履歴" do

    context "ログインしている状態で質問(科目別)の詳細を閲覧すると" do
      it "返信(科目別)の閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        subject_question_reply = create(:subject_question_reply, content: "サンプル返信(科目別)本文", user_id: user.id, subject_question_id: subject_question.id)
        create(:favorite_subject_question_reply, user_id: user2.id, subject_question_reply_id: subject_question_reply.id)

        expect {
          get subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(1)
        expect(response).to have_http_status(200)

        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question_reply_browsing_histories"].length).to eq(1)
          expect(json_response["subject_question_reply_browsing_histories"][0]["user"]["name"]).to eq("東京太郎")
          expect(json_response["subject_question_reply_browsing_histories"][0]["content"]).to eq("サンプル返信(科目別)本文")
          expect(json_response["subject_question_reply_browsing_histories"][0]["favorite_subject_question_replies_count"]).to eq(1)
        end
      end
    end

    context "ログインしている & 返信(科目別)の閲覧履歴が10件存在していると" do
      it "一番古い閲覧履歴が削除された後、返信(科目別)の閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        subject_question_replies = create_list(:subject_question_reply, 10, user_id: user.id, subject_question_id: subject_question.id) do |subject_question_reply, i|
          subject_question_reply.content = "返信(科目別)本文#{i + 1}"
          subject_question_reply.save
        end

        subject_question_replies.each do |subject_question_reply|
          create(:browsing_history, user_id: user.id, subject_question_reply_id: subject_question_reply.id)
        end
        subject_question_reply11 = create(:subject_question_reply, content: "返信(科目別)本文11", user_id: user.id, subject_question_id: subject_question.id)

        # 　閲覧履歴の確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question_reply_browsing_histories"].length).to eq(10)
          expect(json_response["subject_question_reply_browsing_histories"][0]["content"]).to eq("返信(科目別)本文1")
          expect(json_response["subject_question_reply_browsing_histories"][9]["content"]).to eq("返信(科目別)本文10")
        end

        # 閲覧履歴の作成
        get subject_question_subject_question_reply_path(subject_question, subject_question_reply11), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        # 閲覧履歴の再確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["subject_question_reply_browsing_histories"].length).to eq(10)
          expect(json_response["subject_question_reply_browsing_histories"][0]["content"]).to eq("返信(科目別)本文2")
          expect(json_response["subject_question_reply_browsing_histories"][9]["content"]).to eq("返信(科目別)本文11")
        end
      end
    end

    context "対象の返信(科目別)の閲覧履歴がすでに存在すると" do
      it "返信(科目別)の閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        subject_question_reply = create(:subject_question_reply, content: "サンプル返信(科目別)本文", user_id: user.id, subject_question_id: subject_question.id)
        create(:browsing_history, user_id: user.id, subject_question_reply_id: subject_question_reply.id)

        expect {
          get subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "返信(科目別)の閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        subject_question_reply = create(:subject_question_reply, content: "サンプル返信(科目別)本文", user_id: user.id, subject_question_id: subject_question.id)

        expect {
          get subject_question_subject_question_reply_path(subject_question, subject_question_reply), params: {
            current_user_id: -1
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "アンケートの閲覧履歴" do

    context "ログインしている状態でアンケートの詳細を閲覧すると" do
      it "アンケートの閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        survey = create(:survey, title: "サンプルアンケートタイトル", content: "サンプルアンケート本文", genre: "数学", status: false, user_id: user.id)
        create(:survey_answer, selected_option: 1, user_id: user2.id, survey_id: survey.id)
        create(:favorite_survey, user_id: user2.id, survey_id: survey.id)

        expect {
          get survey_path(survey), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(1)
        expect(response).to have_http_status(200)

        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["survey_browsing_histories"].length).to eq(1)
          expect(json_response["survey_browsing_histories"][0]["user"]["name"]).to eq("東京太郎")
          expect(json_response["survey_browsing_histories"][0]["title"]).to eq("サンプルアンケートタイトル")
          expect(json_response["survey_browsing_histories"][0]["content"]).to eq("サンプルアンケート本文")
          expect(json_response["survey_browsing_histories"][0]["genre"]).to eq("数学")
          expect(json_response["survey_browsing_histories"][0]["status"]).to eq(false)
          expect(json_response["survey_browsing_histories"][0]["survey_answers_count"]).to eq(1)
          expect(json_response["survey_browsing_histories"][0]["favorite_surveys_count"]).to eq(1)
        end

      end
    end

    context "ログインしている & アンケートの閲覧履歴が10件存在していると" do
      it "一番古い閲覧履歴が削除された後、アンケートの閲覧履歴が作成される" do
        user = create(:user, name: "東京太郎")
        surveys = create_list(:survey, 10, user_id: user.id) do |survey, i|
          survey.title = "アンケートタイトル#{i + 1}"
          survey.save
        end

        surveys.each do |survey|
          create(:browsing_history, user_id: user.id, survey_id: survey.id)
        end
        survey11 = create(:survey, title: "アンケートタイトル11", user_id: user.id)

        # 　閲覧履歴の確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["survey_browsing_histories"].length).to eq(10)
          expect(json_response["survey_browsing_histories"][0]["title"]).to eq("アンケートタイトル1")
          expect(json_response["survey_browsing_histories"][9]["title"]).to eq("アンケートタイトル10")
        end

        # 閲覧履歴の作成
        get survey_path(survey11), params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        # 閲覧履歴の再確認
        get browsing_histories_path, params: {
          current_user_id: user.id
        }
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        aggregate_failures do
          expect(json_response["survey_browsing_histories"].length).to eq(10)
          expect(json_response["survey_browsing_histories"][0]["title"]).to eq("アンケートタイトル2")
          expect(json_response["survey_browsing_histories"][9]["title"]).to eq("アンケートタイトル11")
        end
      end
    end

    context "対象のアンケートの閲覧履歴がすでに存在すると" do
      it "アンケートの閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        survey = create(:survey, title: "サンプルアンケートタイトル", content: "サンプルアンケート本文", genre: "数学", status: false, user_id: user.id)
        create(:browsing_history, user_id: user.id, survey_id: survey.id)

        expect {
          get survey_path(survey), params: {
            current_user_id: user.id
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない(current_userが存在しない)と" do
      it "アンケートの閲覧履歴が作成されない" do
        user = create(:user, name: "東京太郎")
        survey = create(:survey, title: "サンプルアンケートタイトル", content: "サンプルアンケート本文", genre: "数学", status: false, user_id: user.id)

        expect {
          get survey_path(survey), params: {
            current_user_id: -1
          }
        }.to change(BrowsingHistory, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end

  end





end
