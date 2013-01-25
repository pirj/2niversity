# coding: utf-8
require 'bundler'
require 'logging'
Bundler.require

require 'sinatra/contrib'
require 'sinatra/streaming'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?

Dir['models/*.rb', 'controllers/*.rb'].each { |file| require File.join Dir.pwd, file }

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.db")
DataMapper.finalize
DataMapper.auto_upgrade!

environment = development? ? :development : production? ? :production : :test

CONFIG = {}
[:email, :security].each do |file|
  CONFIG[file] = YAML.load_file("#{Dir.pwd}/config/#{file}.yml")[environment.to_s].symbolize_keys
end

class Site < Sinatra::Base
  register Sinatra::Contrib
  register Sinatra::Flash

  helpers Sinatra::ContentFor
  helpers Sinatra::Streaming

  use Rack::Session::Redis
  use Rack::Protection, except: :session_hijacking

  register Sinatra::Can

  enable :logging

  set :root, Dir.pwd #File.dirname(__FILE__)

  [401, 403, 404, 500].each do |code|
    error(code) do
      slim :"errors/#{code}"
    end
  end

  configure :development do
    register Sinatra::Reloader
    also_reload './*.rb'
    also_reload './models/*.rb'
    also_reload './controllers/*.rb'
  end

  def current_identity
    @current_identity ||= Identity.get(session[:user_id]) if session[:user_id]
  end

  user do
    current_identity
  end

  ability do |identity|
    can :index, :home
  end

  Mail.defaults do
    delivery_method :smtp, CONFIG[:email]
  end

  error(Net::SMTPFatalError) do
    flash['error'] = "Неправильно задан адрес"
    redirect '/'
  end
end
