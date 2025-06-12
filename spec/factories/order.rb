FactoryBot.define do
  factory :order do
    association :merchant, factory: :merchant
    order_id { SecureRandom.uuid }
    merchant_reference { merchant.reference }
    disbursement_id { nil }
    amount { 100.0 }
    created_at { Time.current - 1.day }
    updated_at { Time.current }

  end
end