require "feature_flipper"
class Features
  extend FeatureFlipper

  flipper(:facebook) { Rails.env.production? }
  flipper(:ads) { Rails.env.production? }
  flipper :uservoice, false
  flipper(:analytics) { Rails.env.production? }

  flipper(:backdoor) { Rails.env.test? }
  flipper(:restrict_beta_access) { Features.public? }
  flipper(:login, true)
  flipper(:background_ical_generation) { ENV["BACKGROUND_ICAL_GENERATION"].present? }

  def self.public?
    Rails.env.production? || Rails.env.staging?
  end

end
