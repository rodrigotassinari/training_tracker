require 'rails_helper'

describe WorkoutShare do
  let(:workout) { FactoryGirl.create(:workout) }

  context 'validations' do
    subject { described_class.new(workout: workout, emails: 'foo@bar.com') }
    it { is_expected.to validate_presence_of(:workout) }
    it { is_expected.to validate_presence_of(:emails) }
  end

end