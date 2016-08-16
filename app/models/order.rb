class Order < ActiveRecord::Base
  enum order_status_id: {in_progress: 1, placed: 2, shipped: 3, cancelled: 4}
  belongs_to :order_status
  has_many :order_items
  before_validation :set_order_status, on: :create
  before_save :update_subtotal

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

private
  def set_order_status
    self.order_status_id = "in_progress"
  end

  def update_subtotal
    self[:subtotal] = subtotal
  end
end
