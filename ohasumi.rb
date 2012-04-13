# -*- coding: utf-8 -*-
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require "optparse"
require 'ohasumi'

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
  opts.parse!(argv)

  options.each do |k,option|
    if (config[k] == nil)
      $stderr.puts opts.help
      exit 1
    end
  end

  return config
end


Ohasumi::Bot.new(parse_options(ARGV)).run
