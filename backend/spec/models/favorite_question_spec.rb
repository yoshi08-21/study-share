require 'rails_helper'

RSpec.describe FavoriteQuestion, type: :model do

  describe "question_idカラムのバリデーション" do

    it { is_expected.to validate_uniqueness_of(:question_id).scoped_to(:user_id) }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "questionモデルとのアソシエーション" do

    it { is_expected.to belong_to(:question) }

  end

end
