module Products
  class BaseController < ApplicationController
    before_action :authenticate_user!

    private

    def authenticate_user!
      if check_controller
        user = User.find_by(login_token: request.headers['Authorization']&.split&.last)
        if user
          @current_user = user
        else
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end 
    end

    def current_user
      @current_user
    end
  end
end