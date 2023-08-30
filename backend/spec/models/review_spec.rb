require 'rails_helper'

RSpec.describe Review, type: :model do


  describe "ratingカラムのバリデーション" do

    it { is_expected.to validate_presence_of :rating }
    it { is_expected.to validate_numericality_of(:rating)
                        .only_integer
                        .is_greater_than_or_equal_to(1)
                        .is_less_than_or_equal_to(5) }
    end

    describe "titleカラムのバリデーション" do

      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_length_of(:title).is_at_most(60) }

    end

    describe "contentカラムのバリデーション" do

      it { is_expected.to validate_presence_of :content }
      it { is_expected.to validate_length_of(:content).is_at_most(1000) }

    end

    describe "userモデルとのアソシエーション" do

      it { is_expected.to belong_to(:user) }

    end

    describe "bookモデルとのアソシエーション" do

      it { is_expected.to belong_to(:book) }

    end

    describe "favorite_reviewモデルとのアソシエーション" do

      it { is_expected.to have_many(:favorite_reviews).dependent(:destroy) }

    end

    describe "browsing_historieモデルとのアソシエーション" do

      it { is_expected.to have_many(:browsing_histories).dependent(:destroy) }

    end

    describe "notificationモデルとのアソシエーション" do

      it { is_expected.to have_many(:notifications).dependent(:destroy) }

    end






end
