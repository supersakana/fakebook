class PostsController < ApplicationController
  before_action :set_post, only: %i[destroy edit update show correct_user]
  before_action :correct_user, only: %i[destroy edit update]
  before_action :log_in_user

  def index
    return unless user_signed_in?

    @post = current_user.posts.build
    @feed = current_user.feed.page(params[:page])
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      redirect_to request.referrer
    else
      @feed = current_user.feed.page(params[:page])
      render 'index', status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to root_url, status: :see_other
  end

  def update
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  def show; end

  def edit; end

  private

  def post_params
    params.require(:post).permit(:content, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def correct_user
    redirect_to root_url, status: :see_other unless @post.user == current_user
  end
end
