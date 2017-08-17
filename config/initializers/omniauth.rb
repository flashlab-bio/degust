Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/deg/auth'
#    config.logger = Rails.logger
  end
  provider :github, Rails.application.secrets.github_provider_key, Rails.application.secrets.github_provider_secret, scope: "user"
  provider :weibo, Rails.application.secrets.weibo_provider_key, Rails.application.secrets.weibo_provider_secret,
    {redirect_uri: 'http://fly.redbux.cn/deg/auth/weibo/callback'}
end
