class User < ActiveRecord::Base
  has_and_belongs_to_many :events
  has_and_belongs_to_many :disciplines
  before_create :generate_timetable_id
  has_many :posts
  has_many :comments

  serialize :data, ActiveRecord::Coders::Hstore
  validates :uid, :name, :disciplines, :presence => true

  include Gravtastic
  gravtastic :uid

  def generate_timetable_id
    self.timetable_id = SecureRandom.urlsafe_base64
  end

  def event_dates
    EventDate.joins(:event => :users).where("users.id" => User.first)
  end

  def authorize_status
    if new?
      :signup
    else
      :ok
    end
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

end
