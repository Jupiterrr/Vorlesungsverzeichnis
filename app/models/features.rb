class Features
  extend FeatureFlipper

  flipper(:facebook) { Rails.env.production? }
  flipper :uservoice, false
  flipper(:analytics) { Rails.env.production? }

  flipper(:backdoor) { Rails.env.development?; false }
  flipper(:restrict_beta_access) { Features.public? }
  flipper(:login, true)

  def self.public?
    Rails.env.production? || Rails.env.staging?
  end

end
