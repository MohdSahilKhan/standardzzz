class Api::SessionsController < ActionController::Base
  skip_before_action :verify_authenticity_token
  def create
    user = User.find_for_authentication(email: params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
        user.regenerate_login_token
        sign_in(user)
        render json: { id: user.id, full_name: user.full_name, token: user.login_token, success: true  }, status: :ok
    else
      render json: { error: 'Invalid email or password', success: false }, status: :unauthorized
    end
  end

  def verify_email
    user = User.find_by(email: params[:email])
    if user && user.email_otp == params[:otp]
      user.update(email_otp: nil)
      render json: { message: "Email verified successfully", success: true }, status: :ok
    else
      render json: { error: "Invalid OTP", success: false }, status: :unprocessable_entity
    end
  end

  def verify_mobile
    user = User.find_by(email: params[:email])
    if user && user.mobile_otp == params[:otp]
      user.update(mobile_otp: nil, , is_active: true)
      render json: { message: "Mobile verified successfully", success: true, id: user.id, full_name: user.full_name, token: user.login_token, success: true  }, status: :ok
    else
      render json: { error: "Invalid OTP", success: false }, status: :unprocessable_entity
    end
  end
  def destroy
    sign_out(current_user)
    render json: { message: 'Logged out successfully' }
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
end
