OAuth2::Response.register_parser(:facebook, 'text/plain') do |body|
        token_key, token_value, expiration_key, expiration_value = body.split(/[=&]/)
        {token_key => token_value, expiration_key => expiration_value, :mode => :query, :param_name => 'access_token'}
end