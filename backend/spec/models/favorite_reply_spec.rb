require 'rails_helper'

RSpec.describe FavoriteReply, type: :model do

  describe "reply_idカラムのバリデーション" do

    it { is_expected.to validate_uniqueness_of(:reply_id).scoped_to(:user_id) }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "replyモデルとのアソシエーション" do

    it { is_expected.to belong_to(:reply) }

  end

end
