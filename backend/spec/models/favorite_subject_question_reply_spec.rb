require 'rails_helper'

RSpec.describe FavoriteSubjectQuestionReply, type: :model do

  describe "subject_question_reply_idカラムのバリデーション" do

    it { is_expected.to validate_uniqueness_of(:subject_question_reply_id).scoped_to(:user_id) }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "subject_question_replyモデルとのアソシエーション" do

    it { is_expected.to belong_to(:subject_question_reply) }

  end

end
