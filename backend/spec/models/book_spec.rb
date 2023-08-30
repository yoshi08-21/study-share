require 'rails_helper'

RSpec.describe Book, type: :model do

  describe "nameカラムのバリデーション" do

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }

  end

  describe "authorカラムのバリデーション" do

    it { is_expected.to validate_presence_of :author }
    it { is_expected.to validate_length_of(:author).is_at_most(25) }

  end

  describe "publisherカラムのバリデーション" do

    it { is_expected.to validate_length_of(:publisher).is_at_most(25) }

  end

  describe "subjectカラムのバリデーション" do

    it { is_expected.to validate_presence_of :subject }

  end

  describe "descriptionカラムのバリデーション" do

    it { is_expected.to validate_length_of(:description).is_at_most(1000) }

  end

  describe "userモデルとのアソシエーション" do

    it { is_expected.to belong_to(:user) }

  end


  describe "reviewモデルとのアソシエーション" do

    it { is_expected.to have_many(:reviews).dependent(:destroy) }

  end

  describe "questionモデルとのアソシエーション" do

    it { is_expected.to have_many(:questions).dependent(:destroy) }

  end

  describe "favorite_bookモデルとのアソシエーション" do

    it { is_expected.to have_many(:favorite_books).dependent(:destroy) }

  end

  describe "has_one_attachedの確認" do

    it { is_expected.to have_one_attached(:image) }

  end


end
