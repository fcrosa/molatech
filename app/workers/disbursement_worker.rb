class DisbursementWorker
    include Sidekiq::Worker

        def perform(merchant_reference)
            merchant = Merchant.find_by(reference: merchant_reference)
            DisbursementService.new(merchant).call
        rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error("Merchant not found: #{merchant_id}. Error: #{e.message}")
        rescue StandardError => e
            Rails.logger.error("Failed to process disbursement for merchant #{merchant_id}. Error: #{e.message}")
        raise e
        
        end

end