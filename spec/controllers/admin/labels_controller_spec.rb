require 'rails_helper'

RSpec.describe Admin::LabelsController, type: :controller do

  describe "GET #tote" do
    it "returns http success" do
      get :tote
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #meal" do
    it "returns http success" do
      get :meal
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #ingredient" do
    it "returns http success" do
      get :ingredient
      expect(response).to have_http_status(:success)
    end
  end

end
