class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    users = User.all
    render json: { success: true, users: users }, status: :ok
  end

  def show
    render json: { success: true, user: @user }, status: :ok
  end

  def update
    if @user.update(user_params)
      render json: { success: true, message: "User updated successfully", user: @user }, status: :ok
    else
      render json: { success: false, errors: @user.errors.full_message }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: { success: true, message: "User deleted successfully" }, status: :ok
    else
      render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation,
      :full_name, :mobile_number, :gender,
      :address, :city, :state, :pincode,
      :is_active, :email_otp, :mobile_otp,
      :profile_picture
    )
  rescue ActionController::ParameterMissing
    render json: {
      success: false,
      message: "Required user params are missing"
    }, status: :bad_request
  end

  def set_user
    @user = User.find_by(id: params[:id])

    unless @user
      render json: { success: false, message: "User not found" }, status: :not_found
    end
  end
end
