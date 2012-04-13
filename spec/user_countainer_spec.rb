# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe Ohasumi::UserContainer do
  before do
    @data_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", 'data', 'test'))
    @c = Ohasumi::UserContainer.new(@data_dir)
  end

  it "存在しないユーザgetしたら勝手に作る" do
    @c.user(1).should be_a Ohasumi::User
  end

  it "存在してたらそいつを返す" do
    user = @c.user(1)
    @c.user(1).should equal user
  end

  it "たくさん作れる" do
    [*1..10].each do |i|
      @c.user(i).should be_a Ohasumi::User
      @c.user(i).should equal @c.user(i)
    end
  end

  it "永続化できる" do
    now = Time.now
    Timecop.freeze(now)
    @c.user(1).sleep
    Timecop.freeze(now + 20)
    @c.user(2).sleep

    Timecop.freeze(now + 40)
    @c.dump
    @c = nil;

    @c = Ohasumi::UserContainer.new(@data_dir)
    @c.user(1).sleep_at.should == now
    @c.user(2).sleep_at.should == now + 20
  end

  after do
    Dir.glob(@data_dir + "/*") {|f|
      File.delete(f)
    }
  end
end
