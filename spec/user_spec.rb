# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe User do
  before do
    @user = User.new()
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

end
