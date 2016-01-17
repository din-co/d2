require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  before do
    sign_in nil
  end

  it "should get about" do
    get :show, page: :about
    assert_response :success
  end

  it "should get help" do
    get :show, page: :help
    assert_response :success
  end

  it "should get faq" do
    get :show, page: :faq
    assert_response :success
  end

  it "should get terms" do
    get :show, page: :terms
    assert_response :success
  end

  it "should get privacy" do
    get :show, page: :privacy
    assert_response :success
  end
end
