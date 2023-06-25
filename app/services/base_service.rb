# frozen_string_literal: true

# Base Service class
class BaseService
  attr_reader :error

  def initialize(**kwargs)
    @error = {}
  end

  def call
    return true if successful?

    false
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
