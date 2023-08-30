require 'rails_helper'

RSpec.describe SubjectQuestionReply, type: :model do

  describe "contentカラムのバリデーション" do

    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_length_of(:content).is_at_most(1000) }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "subject_questionモデルとのアソシエーション" do

    it { is_expected.to belong_to(:subject_question) }

  end


  describe "favorite_subject_question_replyモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_subject_question_replies).dependent(:destroy) }

  end

  describe "browsing_historieモデルとのアソシエーション" do

    it { is_expected.to have_many(:browsing_histories).dependent(:destroy) }

  end

  describe "notificationモデルとのアソシエーション" do

    it { is_expected.to have_many(:notifications).dependent(:destroy) }

  end

  describe "has_one_attachedの確認" do

    it { is_expected.to have_one_attached(:image) }

  end


end
