
require 'rubygems'
require 'sinatra'  
require 'erb'
require 'rubyredis'

require 'chat'

set :sessions, true

def redis
  $redis ||= RedisClient.new(:timeout => nil)
end

before do
  keys = redis.keys("*")
end

get '/' do
  erb :index
end

get '/chatbox' do
  @messages = Message.all
  erb :chatbox
end

post '/message' do
  user = session[:user]
  Message.create(user, params[:message])
  redirect '/'
end

post '/user' do
  if params[:user].length > 0
    session[:user] = params[:user]
    redirect '/'
  else
    @user_error = "Wpisz jakiś nick" 
    erb :index
  end
end

helpers do
  def pluralize(singular, plural, count)
    if count == 1
      count.to_s + " " + singular
    else
      count.to_s + " " + plural
    end
  end
  
  def time_ago_in_words(time)
    distance_in_seconds = (Time.now - time).round
    case distance_in_seconds
    when 0..10
      return "dopiero co"
    when 10..60
      return "mniej niż minutę temu"
    end
    distance_in_minutes = (distance_in_seconds/60).round
    case distance_in_minutes
    when 0..1
      return "minutę temu"
    when 2..45
      return distance_in_minutes.round.to_s + " minut temu"
    when 46..89
      return "około godziny temu"
    when 90..1439        
      return (distance_in_minutes/60).round.to_s + " godzin temu"
    when 1440..2879
      return "około dzień temu"
    when 2880..43199
      (distance_in_minutes / 1440).round.to_s + " dni temu"
    when 43200..86399
       "około miesiąca temu"
    when 86400..525599   
      (distance_in_minutes / 43200).round.to_s + " miesięcy temu"
    when 525600..1051199
      "około rok temu"
    else
      "ponad " + (distance_in_minutes / 525600).round.to_s + " lata temu"
    end
  end
end

