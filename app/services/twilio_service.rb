require 'twilio-ruby'

class TwilioService
  def initialize
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    @from = ENV['TWILIO_PHONE_NUMBER']
  end

  def send_otp(to, otp)
    @client.messages.create(
      from: @from,
      to: to,
      body: "Your verification code for Standardzzz is #{otp}"
    )
  end
end
