class DisbursementService

    def initialize(merchant)
        @merchant = merchant               
    end

    def call
        ActiveRecord::Base.transaction do
            # get eligible orders
            eligible_orders = eligible_orders_scope

            # calculate total amount
            total_amount = eligible_orders.sum(:amount)
            total_commission = eligible_orders.sum { |order| order.commission_amount }

            # create record
            disbursement = Disbursement.create!(
                merchant_reference: @merchant.reference,
                amount: total_amount,
                commission: total_commission,
                disbursed_on: Date.current
            )
            # update orders
            eligible_orders.update_all(disbursement_id: disbursement.id)
        end
    end

    private

    def eligible_orders_scope
        # Select orders without a disbursement_id
        @merchant.orders.where(disbursement_id: nil).limit(100)
    end
end