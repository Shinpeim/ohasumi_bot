# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe UserContainer do
  before do
    @c = UserContainer.new()
  end

  it "存在しないユーザgetしたら勝手に作る" do
    @c.user(1).should be_a User
  end

  it "存在してたらそいつを返す" do
    user = @c.user(1)
    @c.user(1).should equal user
  end
end
