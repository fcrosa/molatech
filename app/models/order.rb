class Order < ApplicationRecord

  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
  belongs_to :disbursement, optional: true

  validates :order_id, presence: true, uniqueness: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :created_at, presence: true

end
