module Ohasumi
  class PostError < StandardError
    attr_reader :response

    def initialize(msg, response)
      super(msg)
      @response = response
    end
  end
end
