module Sidekiq
  module Worker; end
end

require 'rails_helper'

RSpec.describe DisbursementWorker, type: :worker do
  describe '#perform' do
    let(:merchant_reference) { 'test_ref' }
    let(:merchant) { instance_double('Merchant') }
    let(:service) { instance_double('DisbursementService') }

    before do
      allow(DisbursementService).to receive(:new).and_return(service)
      allow(service).to receive(:call)
      allow(Rails.logger).to receive(:error)
    end

    context 'when merchant is found and service succeeds' do
      before do
        allow(Merchant).to receive(:find_by).with(reference: merchant_reference).and_return(merchant)
      end

      it 'calls DisbursementService and does not log errors or raise' do
        expect(DisbursementService).to receive(:new).with(merchant)
        expect(service).to receive(:call)
        expect(Rails.logger).not_to receive(:error)
        expect { subject.perform(merchant_reference) }.not_to raise_error
      end
    end

    context 'when Merchant.find_by raises ActiveRecord::RecordNotFound' do
      before do
        allow(Merchant).to receive(:find_by).with(reference: merchant_reference).and_raise(ActiveRecord::RecordNotFound, 'not found')
      end

      it 'results in a NameError due to merchant_id reference in rescue and does not call logger.error' do

        expect(Rails.logger).not_to receive(:error)
        expect { subject.perform(merchant_reference) }.to raise_error(NameError)
      end
    end

    context 'when DisbursementService.call raises a StandardError' do
      before do
        allow(Merchant).to receive(:find_by).with(reference: merchant_reference).and_return(merchant)
        allow(service).to receive(:call).and_raise(StandardError, 'something went wrong')
      end

      it 'results in a NameError due to merchant_id reference in rescue and does not call logger.error for original message' do
        
        expect(Rails.logger).not_to receive(:error)
        expect { subject.perform(merchant_reference) }.to raise_error(NameError)
      end
    end
  end
end
