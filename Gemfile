source 'https://rubygems.org'

# Web server
gem 'thin'
gem 'eventmachine', '~> 1.0.0'

# Web framework
gem 'sinatra'
gem 'sinatra-contrib', :require => 'sinatra/contrib'
gem 'sinatra-flash', :require => 'sinatra/flash'
gem 'sinatra-can', :require => 'sinatra/can'
gem 'rack-protection'
gem 'slim'
gem 'redis-rack', :require => 'rack/session/redis'

# Misc tools
gem 'logging'

# Mail
gem 'mail'

# Database
gem 'datamapper'
%w(core validations timestamps migrations constraints aggregates types pager).each do |g|
  gem 'dm-' + g
end
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'redis'
gem 'hiredis'
gem 'em-hiredis'

# Misc dev tools
group :development do
  gem 'pry'
  gem 'dm-sqlite-adapter'
end
