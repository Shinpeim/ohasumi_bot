# -*- coding: utf-8 -*-
module Ohasumi
  class Bot
    def initialize(options)
      UserStream.configure do |config|
        options.each do |k,v|
          meth_name = k.to_s + '=';
          config.public_send(meth_name,v)
        end
      end

      data_dir_name = case ENV['OHASUMI_ENV']
                      when 'TEST'
                        "test"
                      when 'PROD'
                        "prod"
                      else
                        "dev"
                      end
      @container = UserContainer.new(File.join(File.dirname(__FILE__), 'data', data_dir_name))

      consumer = OAuth::Consumer.new(options[:consumer_key], options[:consumer_secret], :site => "https://api.twitter.com/")
      @access_token = OAuth::AccessToken.new(consumer, options[:oauth_token], options[:oauth_token_secret])
    end

    def oyasumi?(status)
      if status.text =~ /おやすみ/
        return true
      end
      if status.text =~ /寝(る|ます)/
        return true
      end
      return false
    end

    def ohayo?(status)
      if status.text =~ /おはよ[うおー〜]/
        return true
      end
      if status.text =~ /起き(まし)?た/
        return true
      end
      return false
    end

    def oyasumi(status)
      user_id = status.user.id
      @container.user(user_id).sleep

      screen_name = status.user.screen_name
      text = sprintf("@%s おやすみなさい ＜●＞＜●＞",screen_name)
      in_reply_to_status_id = status.id

      #status duplicated対策
      catch(:exit) {
        5.times do
          post("/1/statuses/update.json",{
                 :status => text,
                 :in_reply_to_status_id => in_reply_to_status_id,
               }) do |st|
            throw :exit
          end
          text = text + "　"
        end
      }
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
           }) do |res|
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
      raise ArgumentError, "expected a block" unless block_given?

      token = @access_token
      http = token.consumer.http
      request = token.consumer.create_signed_request(:post, path, token, {}, params, {'User-Agent' => 'ohasumi_bot'})

      #todo エラー制御マシにする
      begin
        http.request(request) do |response|
          code = response.code.to_i
          unless code == 200
            raise StandardError.new response.to_s
          end
          yield response
        end
      rescue => e
        $stderr.puts e
      end
    end

    def run
      client = UserStream.client
      begin
        client.user do |status|
          if ( status.event == "follow" )
            on_follow(status)
          end

          next unless status.text
          next unless status.text =~ /@(おはすみ|執事|メイド|ストーカー|ohasumi_bot)/

          if ( oyasumi?(status) )
            oyasumi(status)
          end

          if ( ohayo?(status) )
            ohayo(status)
          end
        end
      end
    rescue => e
      raise e
    ensure
      @container.dump
    end
  end
end
