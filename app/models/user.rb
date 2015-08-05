class User < ActiveRecord::Base
  has_many :event_subscriptions
  has_and_belongs_to_many :disciplines
  has_many :posts
  has_many :comments
  has_many :sessions
  has_one :ical_file

  serialize :data, ActiveRecord::Coders::Hstore
  validates :uid, :name, :disciplines, :presence => true
  after_create :create_ical_file!

  # include Gravtastic
  # gravtastic :uid

  def event_dates
    EventDate.joins(:event => :users).where("users.id" => User.first)
  end

  def events
    event_ids = event_subscriptions.active.pluck(:event_id)
    Event.where(id: event_ids)
  end

  def admin?
    data["admin_role"] == "true"
  end

  def discipline
    disciplines.first
  end

  def discipline_name
    discipline && discipline.name
  end

  def self.test_user
    find_or_create_by_uid({
      uid: "test@user.edu",
      name: "Test User",
      disciplines: [Discipline.create(name: "Test Discipline")]
    })
  end

  def self.quick_find(query)
    where("uid LIKE :query OR name LIKE :query", {query: "%#{query}%"})
  end

  class << self
    alias_method :qf, :quick_find
  end

end
