class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @users = User.all
    render json: @users
  end
  
  def show
    user = User.find(params[:id])
    # Fetch roles using rolify gem methods
    roles = user.roles.map(&:name)
    if user.present?
      render json: { user: user, roles: roles }, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def create
    @user = User.new(user_params)      
    if @user.save    
      render json: { user: @user, message: "User created successfully", success: true }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  def create
    @user = User.new(user_params)      
    if @user.save    
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(profile_picture: params[:profile_picture])
      render json: { message: 'User Profile picture updated successfully' }
    else
      render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name, :father_name, :mother_name, :linkedin_profile, :contact_no, :personal_email,  :blood_group, :marital_status, :date_of_birth, :uan_no, :esic_no, :employee_id, :employee_type, :job_type, :date_of_joining, :relieving_date, :resignation_date, :resignation_status, :notice_period, :retention_bonus, :retention_time, :retention_bonus_no, :gender, :city, :pincode, :state, :address , :designation , :emergency_contact_no, :profile_picture )
  end

end
