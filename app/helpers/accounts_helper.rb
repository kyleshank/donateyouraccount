module AccountsHelper
  def get_twitter_request_token
    get_request_token(Twitter.consumer_key,
                      Twitter.consumer_secret,
                      "http://twitter.com",
                      "http://#{request.host_with_port}/accounts/oauth_create")
  end

  private

  def get_request_token consumer_key, consumer_secret, site, return_url
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, { :site => site })
    request_token = consumer.get_request_token(:oauth_callback => return_url)

    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    request_token
  end
end
