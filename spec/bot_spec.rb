# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe Ohasumi::Bot do
  before do
    options = {
      :consumer_key => "dummy",
      :consumer_secret => "dummy",
      :oauth_token => "dummy",
      :oauth_token_secret => "dummy",
    }
    @bot = Ohasumi::Bot.new(options)
  end

  it "おやすみtweetを見逃さない" do
    texts = ["aaaajdfjaslおやすみ〜dfhsjaklfewkajp",
             "fdasjk;adkls寝るfjdsa;kf;alkj",
             "fdasjfsd;寝ますdfjsak;fja;sdk"]
    texts.each do |t|
      status = Hashie::Mash.new({:text => t})
      @bot.oyasumi?(status).should be_true
    end
  end

  it "おはようtweetを見逃さない" do
    texts = ["aaaajdfjaslおはようdfhsjaklfewkajp",
             "aaaajdfjaslおはよーdfhsjaklfewkajp",
             "aaaajdfjaslおはよ〜dfhsjaklfewkajp",
             "aaaajdfjaslおはよおdfhsjaklfewkajp",
             "aaaajdfjasl起きたdfhsjaklfewkajp",
             "aaaajdfjasl起きましたdfhsjaklfewkajp"]
    texts.each do |t|
      status = Hashie::Mash.new({:text => t})
      @bot.ohayo?(status).should be_true
    end
  end
end
