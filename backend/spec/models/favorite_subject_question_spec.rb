require 'rails_helper'

RSpec.describe FavoriteSubjectQuestion, type: :model do

  describe "subject_question_idカラムのバリデーション" do

    it { is_expected.to validate_uniqueness_of(:subject_question_id).scoped_to(:user_id) }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "subject_questionモデルとのアソシエーション" do

    it { is_expected.to belong_to(:subject_question) }

  end

end
