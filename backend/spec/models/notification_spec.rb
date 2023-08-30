require 'rails_helper'

RSpec.describe Notification, type: :model do

  describe "Userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:action_user).class_name("User"). with_foreign_key("action_user_id") }
    it { is_expected.to belong_to(:target_user).class_name("User"). with_foreign_key("target_user_id") }

  end

  describe "reviewモデルとのアソシエーション" do

    it { is_expected.to belong_to(:review).optional }

  end

  describe "questionモデルとのアソシエーション" do

    it { is_expected.to belong_to(:question).optional }

  end

  describe "replyモデルとのアソシエーション" do

    it { is_expected.to belong_to(:reply).optional }

  end

  describe "subject_questionモデルとのアソシエーション" do

    it { is_expected.to belong_to(:subject_question).optional }

  end

  describe "subject_question_replyモデルとのアソシエーション" do

    it { is_expected.to belong_to(:subject_question_reply).optional }

  end

  describe "surveyモデルとのアソシエーション" do

    it { is_expected.to belong_to(:survey).optional }

  end

end
