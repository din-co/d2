require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  before do
    sign_in nil
  end

  it "should get about" do
    get :show, path: :about
    assert_response :success
  end

  it "should get help" do
    get :show, path: :help
    assert_response :success
  end

  it "should get faq" do
    get :show, path: :faq
    assert_response :success
  end

  it "should get terms" do
    get :show, path: :terms
    assert_response :success
  end

  it "should get privacy" do
    get :show, path: :privacy
    assert_response :success
  end
end
