require 'rails_helper'

RSpec.describe "FavoriteSurveys", type: :request do
  describe "GET /favorite_surveys" do
    it "works! (now write some real specs)" do
      get favorite_surveys_path
      expect(response).to have_http_status(200)
    end
  end
end
