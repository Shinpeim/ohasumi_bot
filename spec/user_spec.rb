# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe Ohasumi::User do
  before do
    @user = Ohasumi::User.new()
  end

  it "寝た時間を保持できる" do
    sleep_at = Time.now
    Timecop.freeze(sleep_at)
    @user.sleep

    Timecop.freeze(sleep_at + 50)
    @user.sleep_at.should == sleep_at
  end

  it "起きたときに寝てた秒数を返す" do
    sleep_at = Time.now
    Timecop.freeze(sleep_at)
    @user.sleep

    Timecop.freeze(sleep_at + 50)
    @user.awake.should == 50
  end

  it "寝てないときには寝た時間はnil" do
    @user.sleep_at.should == nil
    @user.awake.should == nil
  end

  it "起きたあとは寝た時間はnil" do
    @user.sleep
    @user.awake

    @user.sleep_at.should == nil
    @user.awake.should == nil
  end
end
