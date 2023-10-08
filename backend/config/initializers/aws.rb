unless Rails.env.test?
  access = ENV['AWS_ACCESS_KEY_ID'] || Rails.application.credentials.aws[:access_key_id]
  secret = ENV['AWS_SECRET_ACCESS_KEY'] || Rails.application.credentials.aws[:secret_access_key]

  Aws.config.update({
    region: 'ap-northeast-1',
    credentials: Aws::Credentials.new(access, secret),
  })

  Aws::Rails.add_action_mailer_delivery_method(
    :ses,
    credentials: Aws::Credentials.new(access, secret),
    region: 'ap-northeast-1'
  )
end
