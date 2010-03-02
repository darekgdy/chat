#!/usr/bin/ruby

require "rubygems"
require "sinatra"
require "ohm"
require "haml"

set :haml, {:format => :html5 }
#set :environment, :production
set :sessions, true

Ohm.connect

class Chat < Ohm::Model
  attribute :message

  index :message

  def validate
    assert_present :message
  end

end

get '/' do
  @list = []
  Chat.all.each do |c|
    @list << [c.id.to_i, c.message]
  end
  haml :index
end

post "/" do
  chat = Chat.create :message => params[:message]
  redirect '/'
end
