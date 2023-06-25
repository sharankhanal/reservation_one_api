# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeterminePartnerService, type: :service do
  # valid payload
  let(:payload) do
    {
      "reservation_code": "asdfasdfasdfasdf",
      "start_date": "2021-04-14",
      "end_date": "2021-04-18",
      "nights": 4,
      "guests": 4,
      "adults": 2,
      "children": 2,
      "infants": 0,
      "status": "accepted",
      "guest": {
        "first_name": "Wayne",
        "last_name": "Woodbridge",
        "phone": "639123456789",
        "email": "wayne_woodbridge@test.com"
      },
      "currency": "AUD",
      "payout_price": "4200.00",
      "security_price": "500",
      "total_price": "4700.00"
    }
  end
  
  let(:service) { DeterminePartnerService.new(payload: payload) }

  context 'when valid payload' do
    it 'determines partner' do
      service.call
      expect(service.successful?).to be_truthy
      expect(service.partner).to be_present
    end
  end

  context 'when in valid payload' do
    shared_examples 'call service for invalid payload data' do
      it 'fails and has error' do
        service.call
        expect(service.successful?).not_to be_truthy
        expect(service.error_message).to be_present
        expect(service.partner).to be_blank
      end
    end

    context 'when payload is null' do
      let(:payload) {}

      it_behaves_like 'call service for invalid payload data'
    end

    context 'when payload is present but invalid' do
      let(:payload) do
        { name: Faker::Name.name }
      end

      it_behaves_like 'call service for invalid payload data'
    end
  end
end