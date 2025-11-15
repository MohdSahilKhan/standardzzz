class Api::RegistrationsController < ActionController::Base
  skip_before_action :verify_authenticity_token

    def create
      user = User.new(sign_up_params)
      if user.save
        email_otp = rand(100000..999999).to_s
        user.update(email_otp: email_otp)
        UserMailer.with(user: user, otp: email_otp).send_email_otp.deliver_now
        render json: { message: 'User created successfully, Please verify your Email' }
      else
        render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end
  
    private
    
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :mobile_number, :full_name)
    end
end
