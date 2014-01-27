class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    post.comment(current_user, params[:text])
    head :ok
  end

  def destroy
    comment = Comment.find params[:id]
    if comment.author == current_user
      comment.destroy
      head :ok
    else
      head :unauthorized
    end
  end

end
