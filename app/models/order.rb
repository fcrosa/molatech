# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
  belongs_to :disbursement, optional: true

  validates :order_id, presence: true, uniqueness: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :created_at, presence: true

#  def commission_rate
#    case amount
#    when 0...50 then 0.01
#    when 50...300 then 0.0095
#    else 0.0085
#    end
#  end

#  def commission_amount
#    (amount * commission_rate).round(2)
#  end
end
