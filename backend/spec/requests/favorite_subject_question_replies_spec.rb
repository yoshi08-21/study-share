require 'rails_helper'

RSpec.describe "FavoriteSubjectQuestionReplies", type: :request do
  describe "GET /favorite_subject_question_replies" do
    it "works! (now write some real specs)" do
      get favorite_subject_question_replies_path
      expect(response).to have_http_status(200)
    end
  end
end
