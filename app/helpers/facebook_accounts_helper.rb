module FacebookAccountsHelper
  def get_oauth_client
    OAuth2::Client.new(FACEBOOK_APPLICATION_ID, FACEBOOK_APPLICATION_SECRET,
                       :site => {
                         :url => 'https://graph.facebook.com',
                         :ssl => {
                           :verify => OpenSSL::SSL::VERIFY_PEER,
                           :ca_file => File.join(Rails.root, "lib", "cacert.pem")
                         }
                       })
  end
end