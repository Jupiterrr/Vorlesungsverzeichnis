class Comment < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User'

end
