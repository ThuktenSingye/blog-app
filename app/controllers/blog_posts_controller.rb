class BlogPostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  # @blog_post = BlogPost.find(params[:id]) is repeated
  # Can use except
  before_action :set_blog_post, only: [ :show, :edit, :update, :destroy ]
  # before_action :authorize, only: [ :new, :edit, :create, :update, :destroy ]
  def index
    @blog_posts = user_signed_in? ? BlogPost.sorted : BlogPost.published.sorted
  end
  def show
    # Redirect to root if record is not found
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = current_user.blog_posts.new(blog_post_params)
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
    current_user.blog_posts.destroy
    redirect_to root_path
  end

  private

  def blog_post_params
    # params.require(:blog_post).permit(:title, :body)
    params.expect(blog_post: [ :title, :body , :published_at])
  end

  def set_blog_post
    @blog_post = user_signed_in? ? BlogPost.find(params[:id]) : BlogPost.published.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
  end

  # def authenticate_user!
  #   # Redirect to Log in
  #   redirect_to new_user_session_path, alert: "You need to sign in or sign up before continuing." unless user_signed_in?
  # end
  def authorize
    unless @blog_post.user == current_user
       redirect_to root_path, alert: "You are not authorized to perform this action. "
    end
  end
end
