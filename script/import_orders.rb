require 'csv'

# Path to your CSV file
csv_file_path = Rails.root.join('db', 'seeds', 'support_files', 'orders.csv')

CSV.foreach(csv_file_path, headers: true, col_sep: ';') do |row|
  # Extract data from the row
  order_id = row['id'].presence
  merchant_reference = row['merchant_reference'].presence 
  amount = row['amount'].presence || "0.0"
  created_at = row['created_at'].presence || Time.zone.now.to_s

  # Parse amount as decimal or set default to 0.0
  amount = begin
    BigDecimal(amount)
  rescue
    BigDecimal("0.0")
  end

  # Ensure merchant_reference and order_id exists
   if merchant_reference.nil? || order_id.nil?
    puts "Merchant or OrderID not found. Skipping order creation."
    next
  end

  # Ensure associated merchant exists
  merchant = Merchant.find_by(reference: merchant_reference)
  if merchant.nil?
    puts "Merchant with reference '#{merchant_reference}' not found. Skipping order ID '#{order_id}'."
    next
  end

  # Find or initialize the order by order_id
  order = Order.find_or_initialize_by(order_id: order_id)
  order.merchant_reference = merchant_reference
  order.amount = amount
  order.created_at = created_at
  order.save!
end

puts "Orders import completed successfully."
