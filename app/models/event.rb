class Event < ActiveRecord::Base
  include PgSearch
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper

  has_and_belongs_to_many :vvzs#, uniq: true
  has_many :event_subscriptions
  has_many :event_dates, :dependent => :destroy #, :as => :dates
  has_many :activities, class_name: "EventActivity"
  has_one :board, as: :postable#, :dependent => :destroy

  serialize :linker_attributes, ActiveRecord::Coders::Hstore
  serialize :data, ActiveRecord::Coders::Hstore

  has_paper_trail only: [:user_text_md]

  multisearchable :against => [:name, :no, :lecturer, :description]

  pg_search_scope :vvz_search,
    :against => :name,
    :using => {
      :tsearch => {:prefix => true},
      :trigram => {:prefix => true}
    }

  scope :with_number, lambda { where("name ~ '[0-9]{5,}'") }
  scope :original_with_number, lambda { where("original_name ~ '[0-9]{5,}'") }
  scope :orphans, lambda { joins("LEFT OUTER JOIN events_vvzs ON events_vvzs.event_id = events.id").where("events_vvzs.event_id is NULL") }
  scope :not_orphans, lambda { joins("LEFT OUTER JOIN events_vvzs ON events_vvzs.event_id = events.id").where("events_vvzs.event_id is not NULL") }
  # scope :today, lambda {
  #   joins(:event_dates).where("DATE(start_time) = DATE(?)", Time.now)
  # }

  # scope :not_ended, lambda {
  #   where('end_time > ?', Time.now)
  # }

  # scope :tomorrow, lambda {
  #   joins(:event_dates).where("DATE(start_time) = DATE(?)", Time.now + 1.day)
  # }

  def board
    @board ||= super || create_board
  end

  def users
    event_subscriptions.active.includes(:user).map(&:user)
  end

  def nr
    no || (orginal_no && orginal_no[4..-1])
  end

  def track_activity(action, data={})
    activity = activities.new action: action
    activity[:data] = data
    activity.save
    activity
  end

  def subscribe(user)
    event_subscriptions.create user_id: user.id
  end

  def unsubscribe(user)
    EventUnsubscriber.unsubscribe(user, self)
  end

  def subscribed?(user)
    event_subscriptions.active.exists?(user_id: user.id)
  end

  JSON_PREFIX = "*"

  def name=(name)
    write_attribute(:name, name)
    # ensure that original_name is set
    write_attribute(:original_name, name) if original_name.nil?
  end

  def name
    read_attribute(:name) || original_name || ""
  end

  def to_preload
    children = children!.map { |n| n.preload_id }
    [preload_id, name, children]
  end

  def preload_id
    JSON_PREFIX + id.to_s
  end

  def children!
    events
  end

  def dates; event_dates end

  def week
    EventDate.week(id)
  end

  def group_by_day
    groups = dates.group_by {|d| d["time"] + Date.parse(d["date"]).wday.to_s + d["room"] }
    groups.values.map(&:first)
  end

  def self.to_ical(events)
    RiCal.Calendar do |cal|
      events.each do |event|
        event.dates.each do |date|
          start_time, end_time = date["time"].split("-")
          date_s = date["date"]

          cal.event do |e|
            e.summary     = event.name
            #event.description = "First US Manned Spaceflight\n(NASA Code: Mercury 13/Friendship 7)"
            e.dtstart     = Time.parse(start_time + " " + date_s).getutc
            e.dtend       = Time.parse(end_time + " " + date_s).getutc
            e.location    = date["room"]
            e.url         = event.url
          end
        end
      end
    end
  end

  def website
    external_url(data["website"])
  end

  def as_json(user=nil)
    keys = [:name, :nr, :url, :lecturer].map(&:to_s)
    hash = self.attributes.slice(*keys)
    hash[:type] = simple_type.rstrip
    hash[:description] = j_description
    hash[:data] = data
    if user
      hash[:authenticated] = true
      hash[:subscribed] = subscribed?(user)
    end
    hash
  end

  # only rails should change these attributes
  SAFE_ATTRIBUTES = [:id, :created_at, :updated_at]

  def same_as?(other)
    self.save_attributes == other.save_attributes
  end

  def save_attributes
    ignored_keys = SAFE_ATTRIBUTES.map(&:to_s)
    self.attributes.except(*ignored_keys)
  end

  def find_or_create
    Event.where(self.save_attributes).first || self.save && self
  end

  def simple_type
    self._type.nil? ? "" : self._type[/^([^(, ]*)/]
  end

  def j_description
    in_view = ["SWS", "Website", "Vortragssprache", "VAB"]

    if data = read_attribute(:description)
      hash = JSON.parse data
      rest_hash = hash.except(*in_view)
      text = rest_hash.reduce("") do |s, item|
        s << "<section class=\"desc\">"
        s << "<h4>%s</h4>" % item[0]
        s << auto_link(item[1], sanitize: false)
        s << "</section>"
      end
      html = text.html_safe
    end
  rescue JSON::ParserError => e
    logger.warn e.message
    read_attribute(:description).html_safe
  end

  def self.find_by_no(event_no)
    where("no LIKE ?", "%" + event_no)
  end

  def external_url(url)
    return if url.nil?
    new_url = url =~ /^http/ ? url : "//#{url}"
  end

  def pretty_event_date(date)
    days = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag)
    s = date.start_time
    e = date.end_time
    if s.to_date == s.to_date
      day = days[s.wday][0..1]
      "#{day}, #{s.strftime("%H:%M")}-#{e.strftime("%H:%M")} Uhr, #{s.strftime("%d.%m.%Y")}<br /> #{date.room_name}".html_safe
    else
      "#{s.strftime("%d.%m.%Y %H:%M")} - #{e.strftime("%d.%m.%Y %H:%M")} - #{date.room_name}"
    end
  end

  def open
    host = Rails.env.production? ? "www.kithub.de" : "localhost:3000"
    Launchy.open("http://#{host}/vvz/#{vvzs.first.id}/events/#{id}")
  end

end
