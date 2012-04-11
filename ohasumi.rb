# -*- coding: utf-8 -*-
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require "optparse"
require 'user_stream'
require 'pit'
require 'user_container'
require 'user'

def parse_options(argv)
  options = {
    :consumer_key => "-c CONSUMER_KEY",
    :consumer_secret => "-C CONSUMER_SECRET",
    :oauth_token => "-t OAUTH_TOKEN",
    :oauth_token_secret => "-T OAUTH_TOKEN_SECRET",
  }

  config = {}

  opts = OptionParser.new
  options.each do |k,option|
    opts.on(option){|v| config[k] = v}
  end
  opts.parse!(argv);

  options.each do |k,option|
    if (config[k] == nil)
      $stderr.puts opts.help
      exit 1
    end
  end

  return config
end

class Ohasumi
  def initialize(options)
    UserStream.configure do |config|
      options.each do |k,v|
        meth_name = k.to_s + '=';
        config.public_send(meth_name,v)
      end
    end
    @container = UserContainer.new
    @client = UserStream.client
  end

  def oyasumi?(status)
    if status.text == 'おやすみ'
      return true
    end
    return false
  end

  def ohayo?(status)
    if status.text == 'おはよう'
      return true
    end
    return false
  end

  def oyasumi(status)
    user_id = status.user.id
    @container.user(user_id).sleep
  end

  def ohayo(status)
    user_id = status.user.id

    secs = @container.user(user_id).awake
    return unless secs

    hours = secs.to_f / (60 * 60)
    screen_name = status.user.screen_name

    text = sprintf("@%s %.3f時間寝てましたね ＜●＞＜●＞",screen_name,hours)
    in_reply_to_status_id = status.id

    post("/1/statuses/update.json",{
           :status => text,
           :in_reply_to_status_id => in_reply_to_status_id,
         }) do |status|
      # do nothing
    end
  end

  def on_follow(status)
    post("/1/friendships/create.json",{
           :user_id => status.source.id,
         }) do |res|
      # do nothing
    end
  end

  def post(path, params, &block)
    original_endpoint = @client.endpoint
    @client.endpoint = "https://api.twitter.com"
    @client.post(path, params, &block)
    @client.endpoint = original_endpoint
  end

  def run
    @client.user do |status|
      if ( status.event == "follow" )
        on_follow(status)
      end

      next unless status.text

      if ( oyasumi?(status) )
        oyasumi(status)
      end

      if ( ohayo?(status) )
        ohayo(status)
      end
    end
  end

end

Ohasumi.new(parse_options(ARGV)).run
