class Api::RegistrationsController < ActionController::Base
  skip_before_action :verify_authenticity_token

    def create
      user = User.new(sign_up_params)
      if user.save
        mobile_otp = rand(100000..999999).to_s
        user.update(mobile_otp: mobile_otp)
        TwilioService.new.send_otp("+91#{user.mobile_number}", mobile_otp)
        render json: { message: 'User created successfully, Please verify your Mobile Number' }
      else
        render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end
  
    private
    
    def sign_up_params
      params.require(:user).permit(:mobile_number, :full_name)
    end
end
