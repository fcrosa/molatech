FactoryBot.define do
  factory :merchant do
    sequence(:reference) { |n| "merchant_ref_#{n}" }
    disbursement_frequency { "DAILY" }
    sequence(:email) { |n| "merchant#{n}@example.com" }
  end
end