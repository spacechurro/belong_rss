require 'rubygems'
require 'bundler'

Bundler.require

require './belong_rss.rb'

run Sinatra::Application
