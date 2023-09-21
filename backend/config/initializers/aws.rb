access = Rails.application.credentials.aws[:access_key_id]
secret = Rails.application.credentials.aws[:secret_access_key]

Aws.config.update({
  region: 'ap-northeast-1',
  credentials: Aws::Credentials.new(access, secret),
})

ssm_credentials = Aws::SharedCredentials.new(profile_name: 'ssm_user')
$ssm_client = Aws::SSM::Client.new(credentials: ssm_credentials)
