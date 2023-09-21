Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.production?
      origins 'http://www.study-share.com.s3-website-ap-northeast-1.amazonaws.com'
    else
      origins 'http://localhost:8080'
    end

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
