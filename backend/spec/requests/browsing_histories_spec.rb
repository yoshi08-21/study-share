require 'rails_helper'

RSpec.describe "BrowsingHistories", type: :request do
  describe "GET /browsing_histories" do
    it "works! (now write some real specs)" do
      get browsing_histories_path
      expect(response).to have_http_status(200)
    end
  end
end
