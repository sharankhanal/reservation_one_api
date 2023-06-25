# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PartnerOne::ReservationParser, type: :parser do
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

  let(:parser) { PartnerOne::ReservationParser.new(payload) }

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