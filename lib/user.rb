class User
  def sleep
    @sleep_at = Time.now
  end

  def sleep_at
    return @sleep_at
  end

  def awake
    return Time.now - @sleep_at
  end
end
