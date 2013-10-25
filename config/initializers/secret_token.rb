# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
if Rails.env == 'production' && ENV['SECRET_TOKEN'].present?
  KITBox::Application.config.secret_token = ENV['SECRET_TOKEN']
else
  KITBox::Application.config.secret_token = '44b657363ed3d8f73df08e080ec701126ffba889ff0debe8d6710fceb9d76211374be601403bf04b15a10e949c070c0b9e1cbfdb380069fa49dcab3164eb2971'
end
