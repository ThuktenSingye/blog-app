require 'rails_helper'
require_relative '../support/devise'

RSpec.describe "BlogPosts", type: :request do
  # include ControllerMacros
  # Need to create this since data is not available on test environment
  # let!(:blog) { BlogPost.create(title: "Title One", body: "Body One", ) }
  let(:blog) { FactoryBot.create(:blog_post)}
  let(:blog_attributes) { FactoryBot.attributes_for(:blog_post) }
  let!(:invalid_params) { { blog_post: { title: "", body: "" } } }
  let(:user) { FactoryBot.create(:user) }

  describe "GET /root" do
    before { get root_path }
    subject { response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /index" do
    before { get blog_posts_index_path }
    subject { response }
    it { is_expected.to have_http_status(:ok) }
  end

  describe "GET /show" do
    context "if record exists" do
      before { get blog_post_path(blog) }
      subject { response }
      it { is_expected.to have_http_status :ok }
    end

    context "if record does not exist" do
      before { get blog_post_path(10) }
      subject { response }
      it { should redirect_to(root_path) }
    end
  end

  describe "GET /new" do
    context "if sign in is successful" do
      before do
        sign_in user # Devise helper to log in the user
        get new_blog_post_path
      end
      subject { response }
      it { is_expected.to have_http_status :ok }
    end
  end

  describe "POST /create" do
    before { sign_in user }

    context "with valid params" do
      before { post blog_posts_path, params: { blog_post: blog_attributes } }
      subject { response }
      it { should redirect_to(blog_post_path(BlogPost.last)) }
      it { is_expected.to have_http_status(:found) } # 302 for redirect
    end
    context "with invalid params" do
      before { post blog_posts_path, params: invalid_params }
      subject { response }
      it "does not create a new BlogPost" do
        expect {
          post blog_posts_path, params: invalid_params
        }.not_to change(BlogPost, :count)
      end
      it { is_expected.to have_http_status(:unprocessable_entity) }# 422 status code
      it { is_expected.to render_template(:new) }
    end
  end
  #
  describe "GET /edit" do
    before do
      sign_in user
      get edit_blog_post_path(blog)
    end
    subject { response }
    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template(:edit) }
    # it { expect(assigns(:blog_post)).to eq(blog) }
  end
  describe "PATCH /update" do
    let(:valid_params) { { blog_post: { title: "Updated Title", body: "Updated Body" } } }
    before { sign_in user }

    context "with valid params" do
      before { patch blog_post_path(blog), params: valid_params }
      subject { response }

      it { is_expected.to redirect_to(blog_post_path(blog)) }
      it { is_expected.to have_http_status(:found) } # 302 for redirect
      it { expect(assigns(:blog_post)).to eq(blog) }
    end
    context "with invalid params" do
      before { patch blog_post_path(blog), params: invalid_params }
      subject { response }
      it "unprocessable entity return for invalid params" do
        patch blog_post_path(blog), params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it { is_expected.to render_template(:edit) }
    end
  end

  describe "DELETE /destroy" do
    before { sign_in user }
    context "when the blog post exists" do
      it { expect(delete blog_post_path(blog)).to redirect_to(root_path) }
    end
    context "when record does not exist" do
      it { expect(delete blog_post_path(blog)).to redirect_to(root_path) }
    end
  end
end
