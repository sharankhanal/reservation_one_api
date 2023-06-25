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

# model class for reservation
class Reservation < ApplicationRecord
  belongs_to :guest

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :start_and_end_date

  def start_and_end_date
    if start_date && end_date && start_date >= end_date
      errors.add(:start_date, "can't be greater than or equal to end date")
    end
  end
end
