require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns a successful response" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "includes theme assets and toggle" do
      get root_path

      expect(response.body).to include("subh-vivaah-theme")
      expect(response.body).to match(%r{href="/assets/theme(?:-[^"]+)?\.css"})
      expect(response.body).to include(%(data-controller="theme-toggle"))
    end
  end
end
