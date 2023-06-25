# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ManageReservationService, type: :service do
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

  let(:service) { ManageReservationService.new(params: payload) }

  shared_examples 'call service for valid payload data' do
    it 'succeeds and has no error' do
      service.call
      expect(service.successful?).to be_truthy
      expect(service.error_message).to be_blank
    end
  end

  shared_examples 'call service for invalid payload data' do
    it 'fails and contains error' do
      service.call
      expect(service.successful?).to be_falsey
      expect(service.error_message).to be_present
    end
  end

  it 'succeeds when payload is valid' do
    service.call
    expect(service.successful?).to be_truthy
    expect(service.error_message).to be_blank
  end

  context 'when reservation code is not provided in payload' do
    before { payload[:reservation_code] = nil }

    it_behaves_like 'call service for invalid payload data'
  end

  context 'when guest email is not provided in payload' do
    before { payload[:guest][:email] = nil }

    it_behaves_like 'call service for invalid payload data'
  end

  context 'when reservation start date and end date are same' do
    let(:date) { Date.current }

    before do
      payload[:start_date]  = date
      payload[:end_date]    = date
    end

    it_behaves_like 'call service for invalid payload data'
  end

  context 'when reservation start date is greater than end date' do
    let(:date) { Date.current }

    before do
      payload[:start_date]  = date + 5.days
      payload[:end_date]    = date
    end

    it_behaves_like 'call service for invalid payload data'
  end

  context 'when start date is less than end date' do
    let(:date) { Date.current }

    before do
      payload[:start_date]  = date
      payload[:end_date]    = date + 5.days
    end

    it_behaves_like 'call service for valid payload data'
  end
end
