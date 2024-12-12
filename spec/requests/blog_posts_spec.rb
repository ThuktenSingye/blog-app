require 'rails_helper'

RSpec.describe "BlogPosts", type: :request do
  describe "GET /root" do
    before { get root_path }
    subject { response }
    it { is_expected.to have_http_status(200) }
    # it { is_expected.to respond_with :ok }
  end

  describe "GET /index" do
    before { get blog_posts_index_path }
    subject { response }
    it { is_expected.to have_http_status(:ok) }
  end

  describe "GET /show" do
    # Need to create this since data is not available on test environment
    let!(:blog) { BlogPost.create(title: "Title One", body: "Body One") }
    describe "if record exists" do
      before { get blog_post_path(1) }
      subject { response }
      it { is_expected.to have_http_status(200) }
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
    it { is_expected.to have_http_status(:ok)}
  end

  describe "POST /create" do
    let(:valid_params) { { blog_post: { title: "Title One", body: "Body One" } } }
    let!(:invalid_params) { { blog_post: { title: "", body: "" } } }

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
      # before { post blog_posts_path, params: invalid_params }
      it "returns an unprocessable entity response with missing title and body" do
        post blog_posts_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity) # 422 status code
      end


      it "does not create a new BlogPost" do
        expect {
          post blog_posts_path, params: invalid_params
        }.not_to change(BlogPost, :count)
      end

      it "renders the new template" do
        post blog_posts_path, params: invalid_params
        expect(response).to render_template(:new)
      end
    end
  end
end
