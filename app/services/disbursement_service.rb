class DisbursementService

  def initialize(merchant)
    @merchant = merchant               
  end

  def call
    
    ActiveRecord::Base.transaction do
    
      # get eligible orders
      eligible_orders = eligible_orders_scope
      return if eligible_orders.empty? 
      # calculate total amount
      total_amount = eligible_orders.sum(:amount)
      # calculate commission
      total_commission = eligible_orders.sum do |order|
        calculate_commission(order.amount)
      end
      # create record
      disbursement = Disbursement.create!(
        merchant_reference: @merchant.reference,
        amount: total_amount,
        commission: total_commission.to_f.round(2),
        disbursed_on: Date.current
        )
      # update orders
        eligible_orders.update_all(disbursement_id: disbursement.id)
    end
    
  end

  private

  def eligible_orders_scope
    # Select orders without a disbursement_id
    @merchant.orders.where(disbursement_id: nil)
  end
  
   def calculate_commission(amount)
    case amount
    when 0...50
      amount * 0.01
    when 50...300
      amount * 0.0095
    else
      amount * 0.0085
    end
  end

end