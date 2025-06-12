require 'csv'
require 'securerandom'

csv_file_path = Rails.root.join('db', 'seeds', 'support_files', 'merchants.csv')

CSV.foreach(csv_file_path, headers: true, col_sep: ";") do |row|
  id = row['id'].presence || SecureRandom.uuid
  reference = row['reference'].presence || 'csv_reference_not_found'
  email = row['email'].presence || 'csv_email@not_found'
  live_on_str = row['live_on'].presence || '1970-01-01'
  disbursement_frequency = row['disbursement_frequency'].presence || 'DAILY'
  minimum_monthly_fee = row['minimum_monthly_fee'].presence || 0.0

  activated_on = begin
    Date.parse(live_on_str)
  rescue ArgumentError
    nil
  end

  minimum_monthly_fee = begin
    Float(minimum_monthly_fee)
  rescue ArgumentError, TypeError
    0.0
  end

  # Normalize disbursement_frequency and validate allowed values
  disbursement_frequency = disbursement_frequency.upcase
  unless %w[DAILY WEEKLY].include?(disbursement_frequency)
    disbursement_frequency = 'DAILY'
  end

  merchant = Merchant.find_or_initialize_by(id: id)
  merchant.reference = reference
  merchant.email = email
  merchant.live_on = activated_on
  merchant.disbursement_frequency = disbursement_frequency
  merchant.minimum_monthly_fee = minimum_monthly_fee
  merchant.save!
end
