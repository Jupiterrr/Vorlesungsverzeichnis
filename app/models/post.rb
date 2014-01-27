class Post < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :comments, as: :commentable
  belongs_to :board
  belongs_to :author, class_name: 'User'

  def comment(current_user, text)
    raise NotAuthorized unless allowed_to_comment?(current_user)
    comments.create(author_id: current_user.id, text: text)
  end

  def allowed_to_comment?(current_user)
    board.typed_board.allowed_to_comment?(current_user)
  end

end
