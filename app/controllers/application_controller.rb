class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent
  # include Pagy::Backend
  # before_action :authenticate_user!
  # skip_before_action :verify_authenticity_token, only: :create
  
  private
  def authenticate_user!
    if check_controller
      user = User.find_by(login_token: request.headers['Authorization']&.split&.last)
      if user.nil?
        render json: { error: 'Unauthorized user' }, status: :unauthorized
      else
        sign_in user, store: false
      end
    end 
  end  

  #Added this to skip the authenticate_user! action for password controller actions
  def check_controller 
    boolean = true 
    if params[:controller].eql?("devise/passwords")
      boolean = false
    end 
    boolean 
  end

end