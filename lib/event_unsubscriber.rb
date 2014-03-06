class EventUnsubscriber

  def self.unsubscribe_all(user)
    subscriptions = user.event_subscriptions
    mark_as_deleted(subscriptions, :all)
  end

  def self.unsubscribe(user, event)
    subscriptions = user.event_subscriptions.where(event_id: event.id)
    mark_as_deleted(subscriptions, :single)
  end

  def self.mark_as_deleted(subscriptions, method)
    # update_all does not work with hstore
    subscriptions.active.map do |subscription|
      subscription.deleted_at = Time.now
      subscription.data[:delete_method] = method
      subscription.save!
    end
  end

end
