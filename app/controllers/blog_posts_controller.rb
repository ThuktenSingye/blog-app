class BlogPostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  # @blog_post = BlogPost.find(params[:id]) is repeated
  # Can use except
  before_action :set_blog_post, only: [ :show, :edit, :update, :destroy ]
  def index
    @blog_posts = BlogPost.all
  end
  def show
    # Redirect to root if record is not found
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = BlogPost.new(blog_post_params)

    if @blog_post.save
      puts "Success"
      redirect_to @blog_post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @blog_post = BlogPost.find(params[:id])
  end
  def update
    # @blog_post = BlogPost.find(params[:id])
    if @blog_post.update(blog_post_params)
      redirect_to @blog_post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # @blog_post = BlogPost.find(params[:id])
    @blog_post.destroy
    redirect_to root_path
  end

  private

  def blog_post_params
    # params.require(:blog_post).permit(:title, :body)
    params.expect(blog_post: [ :title, :body ])
  end

  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
  end

  # def authenticate_user!
  #   # Redirect to Log in
  #   redirect_to new_user_session_path, alert: "You need to sign in or sign up before continuing." unless user_signed_in?
  # end
end
