FactoryBot.define do
  factory :disbursement do
    merchant_reference { association(:merchant).reference }
    amount { 0.0 }
    commission { 0.0 }
    disbursed_on { Date.current }
  end
end