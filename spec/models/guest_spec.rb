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
require 'rails_helper'

RSpec.describe Guest, type: :model do

  # let(guest) { build(:guest, email: 'contact@airbnb.com' ) }
  subject { build(:guest, email: 'contact@airbnb.com' ) }

  describe 'associations' do
    it { have_many(:reservations) }
  end

  describe 'validations' do
    it { validate_presence_of(:email) }
    it { validate_uniqueness_of(:email).case_insensitive }
  end
end
