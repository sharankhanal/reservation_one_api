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
#
FactoryBot.define do
  factory :guest do
    email { Faker::Internet.email }
  end
end
