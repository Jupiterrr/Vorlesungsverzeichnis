class PostsController < ApplicationController

  def create
    board = Board.find(params[:board_id]).typed_board
    board.post(current_user, params[:text])
    render json: {}
  end

  def destroy
    post = Post.find params[:id]
    if post.author == current_user
      post.destroy
      head :ok
    else
      head :unauthorized
    end
  end

end
