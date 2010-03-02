#!/usr/bin/ruby

require 'rubygems'

Dir[File.dirname(__FILE__) + '/vendor/*/lib'].each { |d| $:.unshift d }
$:.unshift File.dirname(__FILE__) + '/lib'

require 'sinatra'
require 'ohm'
require 'haml'
require 'partials'

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
  haml :index
end

get '/chat' do 
  @list = []
  Chat.all.each do |c|
    @list << [c.id.to_i, c.message]
  end
  haml :chat
end

post "/" do
  chat = Chat.create :message => params[:message]
  redirect '/'
end
