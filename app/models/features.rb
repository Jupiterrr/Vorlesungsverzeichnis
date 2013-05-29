class Features
  extend FeatureFlipper

  flipper(:login_btn) do |request|
    false
  end

  flipper(:facebook) { Rails.env.production? }
  flipper :uservoice, false
  flipper(:analytics) { Rails.env.production? }

  def self.public?
    Rails.env.production? || Rails.env.staging?
  end

end