class Api::RegistrationsController < ActionController::Base
  skip_before_action :verify_authenticity_token

    def create
      user = User.new(sign_up_params)
      if user.save
        email_otp = rand(100000..999999).to_s
        mobile_otp = rand(100000..999999).to_s
        user.update(email_otp: email_otp, mobile_otp: mobile_otp)
        UserMailer.with(user: user, otp: email_otp).send_email_otp.deliver_now
        # send_mobile_otp(user.mobile_number, mobile_otp)
        render json: { message: 'User created successfully, Please verify your email and mobile' }
      else
        render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end
  
    private
  
    def send_mobile_otp(number, otp)
      client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])
      client.messages.create(
        from: ENV["TWILIO_PHONE_NUMBER"],
        to: number,
        body: "Your verification OTP is #{otp}"
      )
    end
    
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :mobile_number, :full_name)
    end
end
