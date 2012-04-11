class UserContainer
  def initialize(data_dir)
    @path = data_dir + '/user_container_users.marshal'
    @users = {}
    if (File.file?(@path))
      @users = Marshal.load(IO.read(@path))
    end
  end

  def user(user_id)
    unless @users[user_id]
      @users[user_id] = User.new
    end

    @users[user_id]
  end

  def dump
    File.open(@path, "w") do |f|
      f.puts Marshal.dump(@users)
    end
  end
end
