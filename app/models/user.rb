class User < ActiveRecord::Base
  has_many :event_subscriptions
  has_and_belongs_to_many :disciplines
  has_many :posts
  has_many :comments
  has_many :sessions
  has_one :ical_file

  serialize :data, ActiveRecord::Coders::Hstore
  validates :uid, :name, :disciplines, :presence => true
  before_create :create_ical_file

  # include Gravtastic
  # gravtastic :uid

  def event_dates
    EventDate.joins(:event => :users).where("users.id" => User.first)
  end

  def events
    event_ids = event_subscriptions.active.pluck(:event_id)
    Event.where(id: event_ids)
  end

  def authorize_status
    new? ? :signup : :authorized
  end

  def self.authorize_status(user)
    user ? user.authorize_status : :unauthorized
  end

  def new?
    discipline_ids.empty? || name.nil?
  end

  def post_beta!
    data["post_feature_flip"] = "true"
    save!
  end

  def self.sign_in(mail)
    user = find_by_uid(mail)
    if user.nil?
      user = new uid: mail
      user.save validate: false
    end
    user
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

  def authorized?
    true
  end

  def self.test_user
    find_or_create_by_uid({
      uid: "test@user.edu",
      name: "Test User",
      disciplines: [Discipline.create(name: "Test Discipline")]
    })
  end

  private
    def create_ical_file
      user.create_ical_file!
      true
    end

end
