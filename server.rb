#!/usr/bin/ruby

require "rubygems"
require "sinatra"
require "ohm"
require "haml"
require "sass"

set :haml, {:format => :html5 }
set :environment, :production
set :sessions, true

Ohm.connect

get '/' do
  haml :index
end

post "/" do 
  message = params[:message]
  redirect '/'
end
