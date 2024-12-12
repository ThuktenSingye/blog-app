class BlogPostsController < ApplicationController
  def index
    @blog_posts = BlogPost.all
  end

  def show
    @blog_post = BlogPost.find(params[:id])
    # Redirect to root if record is not found
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
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


  private

  def blog_post_params
    # params.require(:blog_post).permit(:title, :body)
    params.expect(blog_post: [:title, :body] )
  end
end

