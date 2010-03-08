#!/usr/bin/ruby

require 'rubygems'

require 'sinatra'
require 'ohm'
require 'haml'

set :haml, {:format => :html5 }
#set :environment, :production

enable :sessions

server ||= Ohm.connect

class Chat < Ohm::Model
  attribute :message

  index :message

  def validate
    assert_present :message
  end

end

get '/' do
  if session[:nick]
    haml :index
  else
    redirect '/nick'
  end
end

get '/nick' do
  haml :nick
end

get '/chat' do 
  @list = []
  Chat.all.each do |c|
    @list << [c.id.to_i, c.message]
  end
  haml :chat
end

post "/" do
  message = "(#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}) <b>#{session[:nick]}</b>: #{params[:message]}"
  chat = Chat.create :message => message
  redirect '/'
end

post "/nick" do
  session[:nick] = params[:nick]
  redirect "/"
end
