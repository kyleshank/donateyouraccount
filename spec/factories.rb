Factory.define(:campaign) do |c|
  c.description "Description"
end

Factory.define(:twitter_account) do |t|
  t.token "token"
  t.secret "secret"
end

Factory.define(:facebook_account) do |f|
  f.token "token"
end