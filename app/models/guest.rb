# frozen_string_literal: true

# == Schema Information
#
# Table name: guests
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  phone      :string
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# model class for guest
class Guest < ApplicationRecord
  has_many :reservations

  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
