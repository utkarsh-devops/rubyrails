class ErrorLogger
  def self.log(message=nil)
    @@test_log ||= Logger.new("#{Rails.root}/log/error.log")
    @@test_log.debug(message) unless message.nil?
  end
end