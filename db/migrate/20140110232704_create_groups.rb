class CreateGroups < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.references :postable, polymorphic: true
      t.hstore :data
    end
    add_index :boards, :postable_id

    create_table :posts do |t|
      t.references :author
      t.references :board
      t.text :text
      t.string :content_type
      t.hstore :data

      t.timestamps
    end
    add_index :posts, :author_id
    add_index :posts, :board_id

    create_table :comments do |t|
      t.references :author
      t.references :commentable, polymorphic: true
      t.text :text
      t.hstore :data

      t.timestamps
    end
    add_index :comments, :author_id
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type

    # create_table :groups do |t|
    #   t.references :poi
    #   t.string :name
    #   t.hstore :data

    #   t.timestamps
    # end
    # create_table :group_subscriptions do |t|
    #   t.references :user
    #   t.references :group
    #   t.string :role
    #   t.hstore :data
    # end
    # add_index :group_subscriptions, :user_id
    # add_index :group_subscriptions, :group_id
  end
end
