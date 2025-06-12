require 'rails_helper'

RSpec.describe ScheduleDisbursements do
  include ActiveSupport::Testing::TimeHelpers

  describe '.eligible_for_disbursement?' do
    let(:merchant) { build(:merchant, disbursement_frequency: frequency) }

    subject { described_class.eligible_for_disbursement?(merchant) }

    context 'when frequency is DAILY' do
      let(:frequency) { 'DAILY' }

      it { is_expected.to be true }
    end

    context 'when frequency is WEEKLY' do
      let(:frequency) { 'WEEKLY' }

      it 'returns false when today is not Monday and frequency is WEEKLY' do
        merchant = build(:merchant, disbursement_frequency: 'WEEKLY')
        travel_to Date.new(2025, 6, 17) do 
          result = ScheduleDisbursements.eligible_for_disbursement?(merchant)
          puts "Merchant frequency: #{merchant.disbursement_frequency}, Date: #{Date.current}, Result: #{result}"
          expect(result).to be false
        end
      end
    end

    context 'when frequency is other' do
      let(:frequency) { 'MONTHLY' }

      it { is_expected.to be false }
    end
  end

  describe '.call' do
    before do
      allow(DisbursementWorker).to receive(:perform_async)
    end

    it 'calls perform_async for eligible merchants only' do
      daily_merchant = create(:merchant, disbursement_frequency: 'DAILY', reference: 'daily_ref')
      weekly_merchant = create(:merchant, disbursement_frequency: 'WEEKLY', reference: 'weekly_ref')
      other_merchant = create(:merchant, disbursement_frequency: 'MONTHLY', reference: 'other_ref')

      travel_to Date.new(2025, 6, 16) do # Monday
        described_class.call
      end

      expect(DisbursementWorker).to have_received(:perform_async).with('daily_ref')
      expect(DisbursementWorker).to have_received(:perform_async).with('weekly_ref')
      expect(DisbursementWorker).not_to have_received(:perform_async).with('other_ref')
    end
  end
end
