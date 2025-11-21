class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  validates :total_price, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "total_price", "created_at", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "order_items"]
  end
end
