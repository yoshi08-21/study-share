require 'rails_helper'

RSpec.describe Survey, type: :model do

  describe "titleカラムのバリデーション" do

    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_length_of(:title).is_at_most(50) }

  end

  describe "contentカラムのバリデーション" do

    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_length_of(:content).is_at_most(1000) }

  end

  describe "option1カラムのバリデーション" do

    it { is_expected.to validate_presence_of :option1 }
    it { is_expected.to validate_length_of(:option1).is_at_most(50) }

  end

  describe "option2カラムのバリデーション" do

    it { is_expected.to validate_presence_of :option2 }
    it { is_expected.to validate_length_of(:option2).is_at_most(50) }

  end

  describe "option3カラムのバリデーション" do

    it { is_expected.to validate_length_of(:option3).is_at_most(50) }

  end

  describe "option4カラムのバリデーション" do

    it { is_expected.to validate_length_of(:option4).is_at_most(50) }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "survey_answerモデルとのアソシエーション" do

    it { is_expected.to have_many(:survey_answers).dependent(:destroy) }

  end

  describe "favorite_surveyモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_surveys).dependent(:destroy) }

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
