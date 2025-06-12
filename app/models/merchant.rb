class Merchant < ApplicationRecord
  
  has_many :orders, foreign_key: :merchant_reference, primary_key: :reference
  has_many :disbursements, foreign_key: :merchant_reference, primary_key: :reference

  validates :disbursement_frequency, presence: true
  validates :reference, presence: true, uniqueness: true
  validates :email, presence: true
  validates :disbursement_frequency, presence: true
  validates :minimum_monthly_fee, numericality: { greater_than_or_equal_to: 0 }

end
