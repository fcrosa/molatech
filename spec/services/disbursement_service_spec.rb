require 'rails_helper'

RSpec.configure do |config|
  config.before(:each) do
    Disbursement.delete_all
    Order.delete_all
    Merchant.delete_all
  end
end

RSpec.describe DisbursementService, type: :service do

  describe '#call' do
    let(:merchant) { create(:merchant, reference: "pfeffer_funk", disbursement_frequency: "DAILY") }
    let!(:orders) do
      create_list(:order, 3, 
        merchant_reference: merchant.reference,
        disbursement_id: nil,
        amount: 100.0,
        created_at: Time.current - 1.day,
        updated_at: Time.current
        )
    end

    
    it 'creates a disbursement record with the correct amounts' do
      service = DisbursementService.new(merchant)

      expect {
        service.call
      }.to change { Disbursement.count }.by(1)

      disbursement = Disbursement.last

      total_commission = orders.sum do |order|
        case order.amount
        when 0...50
          order.amount * 0.01
        when 50...300
          order.amount * 0.0095
        else
          order.amount * 0.0085
        end
      end

      expect(disbursement.merchant_reference).to eq(merchant.reference)
      expect(disbursement.amount).to eq(300.0) # 3 orders x 100 each one
      expect(disbursement.commission.to_f).to eq(total_commission.round(2))
    end

    it 'calculates the correct commission for orders at the boundary values of 50 and 300' do
      # Set up orders with amounts at the boundary values
      orders.first.update!(amount: 49.00)   # less than €50
      orders.second.update!(amount: 300.0) # Exactly €300
      orders.third.update!(amount: 200.0)  # Between €50 and €300

      service = DisbursementService.new(merchant)
      service.call

      disbursement = Disbursement.last

      # Calculate the expected commission based on the rules
      total_commission = orders.sum do |order|
        case order.amount
        when 0...50
          order.amount * 0.01
        when 50...300
          order.amount * 0.0095
        else
          order.amount * 0.0085
        end
      end

      expect(disbursement.commission.to_f).to eq(total_commission.round(2))
    end

    it 'associates eligible orders with the disbursement' do
      service = DisbursementService.new(merchant)
      
      service.call

      disbursement = Disbursement.last
      eligible_orders = orders.map(&:reload)

      expect(eligible_orders.all? { |order| order.disbursement_id == disbursement.id }).to be_truthy
    end

    it 'does not create a disbursement if there are no eligible orders' do
      orders.each { |order| order.update!(disbursement_id: SecureRandom.uuid) }
      orders.each(&:reload) 
      
      service = DisbursementService.new(merchant)
      
      expect {
        service.call
      }.not_to change { Disbursement.count }
    end

    it 'rolls back changes if an error occurs' do
      # Force an error inside the transaction to trigger rollback
      allow_any_instance_of(Disbursement).to receive(:save!).and_raise(StandardError)

      service = DisbursementService.new(merchant)
      
      expect {
        begin
          service.call
        rescue StandardError
          # swallow error to test rollback
        end
      }.not_to change { Disbursement.count }
      
      expect(orders.all? { |order| order.disbursement_id.nil? }).to be_truthy
    end

    it 'includes orders created today' do
      recent_order = create(
        :order,
        merchant_reference: merchant.reference,
        disbursement_id: nil,
        amount: 50.0,
        created_at: Time.current
      )

      service = DisbursementService.new(merchant)
      service.call

      expect(recent_order.reload.disbursement_id).not_to be_nil
    end

    it 'handles a large number of orders efficiently' do
      create_list(:order, 100, merchant_reference: merchant.reference, disbursement_id: nil, amount: 100.0)
      service = DisbursementService.new(merchant)
  
      expect { service.call }.to change { Disbursement.count }.by(1)
    end

  end
end
