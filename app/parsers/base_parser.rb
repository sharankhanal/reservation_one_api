# frozen_string_literal: true
# Base Parser class
class BaseParser
  attr_reader :error
  attr_reader :payload
  attr_reader :parsed_payload

  def initialize(payload)
    @payload = payload
    @error = {}
  end

  def parse
    {}
  end

  def successful?
    error.none?
  end

  def error_message
    error[:message]
  end

  private

  def add_error(message)
    @error = { message: message }
  end

  def log_error(message)
    Rails.logger.error("[ERROR]:[#{self.class}]: #{message}")
  end
end
