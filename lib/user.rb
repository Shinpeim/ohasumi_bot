class User
  def sleep
    @sleep_at = Time.now
  end

  def sleep_at
    return @sleep_at
  end

  def awake
    return nil unless @sleep_at
    secs = Time.now - @sleep_at
    @sleep_at = nil
    return secs
  end
end
