class AddEmailOtpAndMobileOtpToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email_otp, :string
    add_column :users, :mobile_otp, :string
  end
end
