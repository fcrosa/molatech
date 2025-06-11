#/app/services/schedule_disbursements.rb
class ScheduleDisbursements

    def self.call
   
        Merchant.all.each do |merchant|
            next unless eligible_for_disbursement?(merchant)
            DisbursementWorker.perform_async(merchant.reference)
        end
   
    end


    
    def self.eligible_for_disbursement?(merchant)
        
        case merchant.disbursement_frequency
        when 'DAILY'
            true
        when 'WEEKLY'
            Date.current.wday == 1 # Monday
        else
            false
        end
   
    end

end
