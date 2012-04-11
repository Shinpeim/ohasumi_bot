class UserContainer
  def initialize
    @users = {}
  end

  def user(user_id)
    unless @users[user_id]
      @users[user_id] = User.new
    end
    @users[user_id]
  end
end
