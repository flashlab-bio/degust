Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/deg/auth'
  end
  provider :github, Rails.application.secrets.github_provider_key, Rails.application.secrets.github_provider_secret, scope: "user"
  provider :google_oauth2, Rails.application.secrets.google_provider_key, Rails.application.secrets.google_provider_secret
end
