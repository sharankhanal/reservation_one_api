# frozen_string_literal: true

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

FactoryBot.define do
  factory :reservation do
    code { Faker::Alphanumeric.alphanumeric[0..12] }
    start_date { Date.current }
    end_date { Date.current + 2.days }
  end
end
