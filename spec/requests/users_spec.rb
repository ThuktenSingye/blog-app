# frozen_string_literal: true
require 'rails_helper'
require_relative '../support/devise'

RSpec.describe "Users", type: :request do
  # For User login
  let(:valid_user) { FactoryBot.create(:user) }
  let(:valid_user_params) { { email: valid_user.email, password: valid_user.password } }
  let(:invalid_user_params) { { email: "wrong@example.com", password: "wrongpassword" } }

  describe "login in" do
    context "when credential are correct" do
      before { post user_session_path, params: { user: valid_user_params } }

      subject { response }
      it { is_expected.to redirect_to root_path }
      it { is_expected.to have_http_status :see_other }
    end
    context "when credentials are incorrect" do
      before { post user_session_path, params: { user:  invalid_user_params } }
      subject { response }
      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end

  describe "sign out" do
    context "when log in" do
      before { post user_session_path, params: { user: valid_user_params} }
      subject { response }
      it { is_expected.to redirect_to root_path }
      it { is_expected.to have_http_status :see_other }
    end

  end

end


