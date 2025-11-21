class Product < ApplicationRecord
  has_many :cart_items
  has_many :order_items

  validates :name, :price, :stock, presence: true
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "description", "colour", "size", "price", "stock", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
