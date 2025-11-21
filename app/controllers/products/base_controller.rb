module Products
  class BaseController < ApplicationController
    before_action :authenticate_user!

    private

    def authenticate_user!
      token = request.headers["Authorization"]
      user = User.find_by(login_token: token)

      if user
        @current_user = user
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    def current_user
      @current_user
    end
  end
end
