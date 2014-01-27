class Board < ActiveRecord::Base

  belongs_to :postable, polymorphic: true
  has_many :posts, :dependent => :destroy

  def typed_board
    board_class = "#{postable_type.classify}Board".constantize
    self.becomes(board_class)
  end

  def allowed_to_post?(current_user)
    raise NotImplementedError
  end

  def allowed_to_comment?(current_user)
    raise NotImplementedError
  end

  def post(current_user, text)
    raise NotAuthorized unless allowed_to_post?(current_user)
    posts.create(author_id: current_user.id, text: text)
  end

  class NotAuthorized < StandardError; end

end

class EventBoard < Board

  def event
    @event ||= Event.find(postable_id)
  end

  def allowed_to_post?(current_user)
    current_user.authorized? && event.subscribed?(current_user)
  end

  def allowed_to_comment?(current_user)
    current_user.authorized? && event.subscribed?(current_user)
  end

end
