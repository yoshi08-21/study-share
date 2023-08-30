require 'rails_helper'

RSpec.describe SurveyAnswer, type: :model do

  describe "selected_optionカラムのバリデーション" do

    it { is_expected.to validate_presence_of :selected_option }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "surveyモデルとのアソシエーション" do

    it { is_expected.to belong_to(:survey) }

  end

end
