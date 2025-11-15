class UserMailer < ApplicationMailer

  def send_email_otp
    @user = params[:user]
    @otp = params[:otp]
    mail(to: @user.email, subject: 'Your Email Verification OTP')
  end
end
