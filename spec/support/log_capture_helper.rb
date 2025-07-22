# frozen_string_literal: true

module LogCaptureHelper
  def capture_log(level: Logger::DEBUG)
    output = StringIO.new
    logger = Logger.new(output)
    logger.level = level
    SqlLint::Log.logger = logger
    yield
    output.rewind
    output.string
  end
end
