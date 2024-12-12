require 'rails_helper'

RSpec.describe "BlogPosts", type: :request do
  # Need to create this since data is not available on test environment
  let!(:blog) { BlogPost.create(title: "Title One", body: "Body One") }
  let!(:invalid_params) { { blog_post: { title: "", body: "" } } }

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
    describe "if record exists" do
      before { get blog_post_path(1) }
      subject { response }
      it { is_expected.to have_http_status :ok }
    end

    describe "if record does not exist" do
      before { get blog_post_path(2) }
      subject { response }
      it { should redirect_to(root_path) }
    end
  end

  describe "GET /new" do
    before { get new_blog_post_path }
    subject { response }
    it { is_expected.to have_http_status(:ok) }
  end

  describe "POST /create" do
    let(:valid_params) { { blog_post: { title: "Title One", body: "Body One" } } }

    context "with valid params" do
      before { post blog_posts_path, params: valid_params }
      subject { response }

      it "creates a new BlogPost" do
        # change method to be used to block that execute the code
        expect {
          post blog_posts_path, params: valid_params
        }.to change(BlogPost, :count).by(1)
      end

      it "redirects to the newly created blog post" do
        is_expected.to redirect_to(blog_post_path(BlogPost.last))
      end

      it "returns a success response" do
        is_expected.to have_http_status(:found) # 302 for redirect
      end
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

  describe "GET /edit" do
    let!(:blog) { BlogPost.create(title: "Title One", body: "Body One") }
    before { get edit_blog_post_path(blog) }
    subject { response }
    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template(:edit) }
    # it { expect(assigns(:blog_post)).to eq(blog) }
  end
  describe "PATCH /update" do
    let(:valid_params) { { blog_post: { title: "Updated Title", body: "Updated Body" } } }

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
    context "when the blog post exists" do
      it "deletes the blog post" do
        expect {
          delete blog_post_path(blog)
        }.to change(BlogPost, :count).by(-1)
      end
      it { expect(delete blog_post_path(blog)).to redirect_to(root_path) }
    end
    context "when record does not exist" do
      it "don't deletes the blog post" do
        delete blog_post_path(18)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
