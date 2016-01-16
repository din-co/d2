require 'rails_helper'

RSpec.describe Admin::RawReportsController, type: :controller do

  describe "GET #outbound_shipments" do
    it "returns http success" do
      pending "admin user authentication"
      get :outbound_shipments
      expect(response).to have_http_status(:success)
    end
  end

end
