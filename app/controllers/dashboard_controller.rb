class DashboardController < ApplicationController

  before_filter :authorize

  def index
    dates = EventDate.where(event_id: current_user.events).includes(:event)
    today = dates.today.not_ended
    if today.empty?
      if Time.now.wday < 5
        @upcomming = dates.tomorrow
      else
        @upcomming = dates.day(date_of_next_monday)
      end
    else
      @upcomming = today
    end
    
    
    #@activities = EventActivity.user_feed(current_user).limit(20)
    @user_events = current_user.events.order(:name)
  end

  private

  def date_of_next_monday
    date  = Date.parse("Monday")
    delta = date > Date.today ? 0 : 7
    date + delta
  end

end
