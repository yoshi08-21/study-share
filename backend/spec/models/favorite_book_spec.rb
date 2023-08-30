require 'rails_helper'

RSpec.describe FavoriteBook, type: :model do

  describe "book_idカラムのバリデーション" do

    it { is_expected.to validate_uniqueness_of(:book_id).scoped_to(:user_id) }


  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end

  describe "bookモデルとのアソシエーション" do

    it { is_expected.to belong_to(:book) }

  end

end
