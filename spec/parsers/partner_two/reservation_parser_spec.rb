# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PartnerTwo::ReservationParser, type: :parser do
  let(:payload) do
    {
      "reservation": {
        "code": "XXX12345678",
        "start_date": "2021-03-12",
        "end_date": "2021-03-16",
        "expected_payout_amount": "3800.00",
        "guest_details": {
          "localized_description": "4 guests",
          "number_of_adults": 2,
          "number_of_children": 2,
          "number_of_infants": 0
        },
        "guest_email": "wayne_woodbridge@bnb.com",
        "guest_first_name": "Wayne",
        "guest_last_name": "Woodbridge",
        "guest_phone_numbers": [
          "639123456789",
          "639123456789"
        ],
        "listing_security_price_accurate": "500.00",
        "host_currency": "AUD",
        "nights": 4,
        "number_of_guests": 4,
        "status_type": "accepted",
        "total_paid_amount_accurate": "4300.00"
      }
    }
  end

  let(:parser) { PartnerTwo::ReservationParser.new(payload) }

  context 'when paylod is known' do
    it 'succeeds and provides parsed payload' do
      parser.parse 
      expect(parser.successful?).to be_truthy
      expect(parser.parsed_payload).to be_present
    end
  end

  context 'when paylod is null' do
    let(:payload) { nil }

    it 'fails and does not provide parsed payload' do
      parser.parse 
      expect(parser.successful?).to be_falsey
      expect(parser.parsed_payload).to be_blank
    end
  end
end