require 'rails_helper'

RSpec.describe BrowsingHistory, type: :model do

  describe "Userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "bookモデルとのアソシエーション" do

    it { is_expected.to belong_to(:book).optional }

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
