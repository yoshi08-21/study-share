require 'rails_helper'

RSpec.describe FavoriteSurvey, type: :model do

  describe "survey_idカラムのバリデーション" do

    it { is_expected.to validate_uniqueness_of(:survey_id).scoped_to(:user_id) }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "surveyモデルとのアソシエーション" do

    it { is_expected.to belong_to(:survey) }

  end

end
