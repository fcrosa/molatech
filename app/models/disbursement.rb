# app/models/disbursement.rb
class Disbursement < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
  has_many :orders
  before_validation :generate_reference, on: :create

  validates :reference, presence: true, uniqueness: true
  validates :disbursed_on, presence: true

  def total_amount
    orders.sum(:amount).round(2)
  end

  def total_commission
    orders.map(&:commission_amount).sum.round(2)
  end

  def net_amount
    (total_amount - total_commission).round(2)
  end

  private

  def generate_reference
    self.reference ||= SecureRandom.uuid
  end

end
