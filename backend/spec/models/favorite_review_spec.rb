require 'rails_helper'

RSpec.describe FavoriteReview, type: :model do

  describe "review_idカラムのバリデーション" do

    it { is_expected.to validate_uniqueness_of(:review_id).scoped_to(:user_id) }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "reviewモデルとのアソシエーション" do

    it { is_expected.to belong_to(:review) }

  end


end
