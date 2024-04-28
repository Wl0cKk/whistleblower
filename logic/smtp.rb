require 'net/smtp'

class MailService
  attr_reader :smtp

  def initialize(configuration)
    @smtp = Net::SMTP.new(configuration['host'], configuration['port'])
    @smtp.enable_starttls
    @configuration = configuration
  end

  def send_mail(from_email, to_email, message, password)
    @smtp.start(
      @configuration['domain'],
      from_email,
      password,
      :login
    ) do |smtp|
      smtp.send_message(message, from_email, to_email)
    end
  end
end

