# == Schema Information
#
# Table name: reservations
#
#  id             :integer          not null, primary key
#  code           :string           not null
#  start_date     :date
#  end_date       :date
#  nights         :integer
#  guests         :integer
#  adults         :integer
#  children       :integer
#  infants        :integer
#  status         :string
#  currency       :string
#  payout_price   :decimal(10, 2)
#  security_price :decimal(10, 2)
#  total_price    :decimal(10, 2)
#  guest_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'validations' do
    let(:guest) { create(:guest) }
    let(:reservation) { build(:reservation, guest: guest) }

    it 'validates reservation' do
      expect(reservation).to be_valid
    end

    it 'invalidates reservation with no guest associated' do
      reservation.guest = nil

      expect(reservation).not_to be_valid
    end

    it 'invalidates when start date is not provided' do
      reservation.start_date = nil

      expect(reservation).not_to be_valid
    end

    it 'invalidates when end date is not provided' do
      reservation.end_date = nil

      expect(reservation).not_to be_valid
    end

    it 'invalidates when start date is greater than or equal to end date' do
      reservation.start_date = Date.today
      reservation.end_date = Date.today

      expect(reservation).not_to be_valid
    end

    it 'invalidates reservation if code is not unique' do
      existing_reservation = create(:reservation, guest: guest)
      reservation.code = existing_reservation.code.upcase

      expect(reservation).not_to be_valid
    end
  end
end
