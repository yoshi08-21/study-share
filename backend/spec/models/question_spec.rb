require 'rails_helper'

RSpec.describe Question, type: :model do

  describe "titleカラムのバリデーション" do

    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_length_of(:title).is_at_most(60) }

  end

  describe "contentカラムのバリデーション" do

    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_length_of(:content).is_at_most(1000) }

  end

  describe "subjectカラムのバリデーション" do

    it { is_expected.to validate_presence_of :subject }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "bookモデルとのアソシエーション" do

    it { is_expected.to belong_to(:book) }

  end

  describe "replyモデルとのアソシエーション" do

    it { is_expected.to have_many(:replies).dependent(:destroy) }

  end

  describe "favorite_questionモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_questions).dependent(:destroy) }

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
