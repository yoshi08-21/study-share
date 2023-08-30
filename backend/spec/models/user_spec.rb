require 'rails_helper'

RSpec.describe User, type: :model do

  describe "nameカラムのバリデーション" do

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }

  end

  describe "emailカラムのバリデーション" do

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_length_of(:email).is_at_most(250) }

  end

  describe "first_choice_schoolカラムのバリデーション" do

    it { is_expected.to validate_length_of(:first_choice_school).is_at_most(30) }

  end


  describe "second_choice_schoolカラムのバリデーション" do

    it { is_expected.to validate_length_of(:second_choice_school).is_at_most(30) }

  end

  describe "third_choice_schoolカラムのバリデーション" do

    it { is_expected.to validate_length_of(:third_choice_school).is_at_most(30) }

  end

  describe "introductionカラムのバリデーション" do

    it { is_expected.to validate_length_of(:introduction).is_at_most(200) }

  end

  describe "memoカラムのバリデーション" do

    it { is_expected.to validate_length_of(:memo).is_at_most(10000) }

  end

  describe "bookモデルとのアソシエーション" do

    it { is_expected.to have_many :books }

  end

  describe "reviewモデルとのアソシエーション" do

    it { is_expected.to have_many(:reviews).dependent(:destroy) }

  end

  describe "questionモデルとのアソシエーション" do

    it { is_expected.to have_many(:questions).dependent(:destroy) }

  end

  describe "replyモデルとのアソシエーション" do

    it { is_expected.to have_many(:replies).dependent(:destroy) }

  end

  describe "subject_questionモデルとのアソシエーション" do

    it { is_expected.to have_many(:subject_questions).dependent(:destroy) }

  end

  describe "subject_question_replyモデルとのアソシエーション" do

    it { is_expected.to have_many(:subject_question_replies).dependent(:destroy) }

  end

  describe "surveyモデルとのアソシエーション" do

    it { is_expected.to have_many(:surveys).dependent(:destroy) }

  end

  describe "survey_answerモデルとのアソシエーション" do

    it { is_expected.to have_many(:survey_answers).dependent(:destroy) }

  end

  describe "favorite_bookモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_books).dependent(:destroy) }
    it { is_expected.to have_many(:fav_books).through(:favorite_books).source(:book) }

  end

  describe "favorite_reviewモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_reviews).dependent(:destroy) }
    it { is_expected.to have_many(:fav_reviews).through(:favorite_reviews).source(:review) }

  end

  describe "favorite_questionモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_questions).dependent(:destroy) }
    it { is_expected.to have_many(:fav_questions).through(:favorite_questions).source(:question) }

  end

  describe "favorite_replyモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_replies).dependent(:destroy) }
    it { is_expected.to have_many(:fav_replies).through(:favorite_replies).source(:reply) }

  end

  describe "favorite_subject_questionモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_subject_questions).dependent(:destroy) }
    it { is_expected.to have_many(:fav_subject_questions).through(:favorite_subject_questions).source(:subject_question) }

  end

  describe "favorite_subject_question_replyモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_subject_question_replies).dependent(:destroy) }
    it { is_expected.to have_many(:fav_subject_question_replies).through(:favorite_subject_question_replies).source(:subject_question_reply) }

  end

  describe "favorite_surveyモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_surveys).dependent(:destroy) }
    it { is_expected.to have_many(:fav_surveys).through(:favorite_surveys).source(:survey) }

  end

  describe "browsing_historyモデルとのアソシエーション" do

    it { is_expected.to have_many(:browsing_histories).dependent(:destroy) }
    it { is_expected.to have_many(:watched_books).through(:browsing_histories).source(:book) }
    it { is_expected.to have_many(:watched_reviews).through(:browsing_histories).source(:review) }
    it { is_expected.to have_many(:watched_questions).through(:browsing_histories).source(:question) }
    it { is_expected.to have_many(:watched_replies).through(:browsing_histories).source(:reply) }
    it { is_expected.to have_many(:watched_subject_questions).through(:browsing_histories).source(:subject_question) }
    it { is_expected.to have_many(:watched_subject_question_replies).through(:browsing_histories).source(:subject_question_reply) }
    it { is_expected.to have_many(:watched_surveys).through(:browsing_histories).source(:survey) }

  end

  describe "notificationモデルとのアソシエーション" do

    it { is_expected.to have_many(:sent_notifications).class_name("Notification").with_foreign_key("action_user_id").dependent(:destroy) }
    it { is_expected.to have_many(:received_notifications).class_name("Notification").with_foreign_key("target_user_id").dependent(:destroy) }

  end

  describe "has_one_attachedの確認" do

    it { is_expected.to have_one_attached(:image) }

  end













end
