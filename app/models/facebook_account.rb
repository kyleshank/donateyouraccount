class FacebookAccount < Account
  include FacebookAccountsHelper
  include RetryHelper
  
  def get(uri, opts = {})
    try_to do
      @graph ||= get_oauth_client.web_server.get_access_token(self.token, :redirect_uri => FACEBOOK_OAUTH_REDIRECT)
      JSON.parse(@graph.get(uri, opts))
    end
  end

  def post(uri, opts = {})
    try_to do
      @graph ||= get_oauth_client.web_server.get_access_token(self.token, :redirect_uri => FACEBOOK_OAUTH_REDIRECT)
      JSON.parse(@graph.post(uri, opts))
    end
  end

  def url
    "http://facebook.com/profile.php?id=#{self.uid}"
  end

  def recent_links(_id)
    get("/#{_id}/links")
  end

  def share(_data)
    d = _data.dup
    d.delete("from")
    d.delete("actions")
    d.delete("created_time")
    d.delete("updated_time")
    d.delete("privacy")
    d.delete("message")
    d.delete("id")
    try_to do
      @graph ||= get_oauth_client.web_server.get_access_token(self.token, :redirect_uri => FACEBOOK_OAUTH_REDIRECT)
      @graph.post("/me/links", d)
    end
  end

  def facebook_pages
    self["facebook_pages"].blank? ? [] : JSON.parse(self["facebook_pages"])
  end

  def profile_image_url
    "http://graph.facebook.com/#{self.uid}/picture"
  end
end