# app/models/disbursement.rb
class Disbursement < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
  has_many :orders
  before_validation :generate_reference, on: :create

  validates :reference, presence: true, uniqueness: true
  validates :disbursed_on, presence: true

  private

  def generate_reference
    self.reference ||= SecureRandom.uuid
  end

end
