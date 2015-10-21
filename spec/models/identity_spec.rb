require 'rails_helper'

RSpec.describe Identity, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    subject { FactoryGirl.build(:identity) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_inclusion_of(:provider).
          in_array(%w(strava)) }
    it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:user_id) }
    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }
  end

end
