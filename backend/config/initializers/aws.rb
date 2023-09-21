access = Rails.application.credentials.aws[:access_key_id]
secret = Rails.application.credentials.aws[:secret_access_key]

Aws.config.update({
  region: 'ap-northeast-1',
  credentials: Aws::Credentials.new(access, secret),
})

