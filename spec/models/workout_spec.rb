require 'rails_helper'

RSpec.describe Workout, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    subject { FactoryGirl.build(:workout) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to validate_inclusion_of(:kind).
          in_array(Workout::KINDS) }
    it { is_expected.to validate_presence_of(:scheduled_on) }
    # TODO add .only_integer to these tests after shoulda-matchers is fixed (post v3.0.1)
    it { is_expected.to validate_numericality_of(:elapsed_time).is_greater_than_or_equal_to(0).allow_nil }
    it { is_expected.to validate_numericality_of(:moving_time).is_greater_than_or_equal_to(0).allow_nil }
    it { is_expected.to validate_numericality_of(:cadence_avg).is_greater_than_or_equal_to(0).allow_nil }
    it { is_expected.to validate_numericality_of(:cadence_max).is_greater_than_or_equal_to(0).allow_nil }
    it { is_expected.to validate_numericality_of(:calories).is_greater_than_or_equal_to(0).allow_nil }
    it { is_expected.to validate_numericality_of(:heart_rate_avg).is_greater_than_or_equal_to(0).allow_nil }
    it { is_expected.to validate_numericality_of(:heart_rate_max).is_greater_than_or_equal_to(0).allow_nil }
    # /TODO
    it { is_expected.to validate_numericality_of(:distance).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:speed_avg).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:speed_max).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:elevation_gain).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:temperature_avg).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:temperature_max).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:temperature_min).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:watts_avg).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:watts_weighted_avg).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:watts_max).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:weight_before).is_greater_than_or_equal_to(0.0).allow_nil }
    it { is_expected.to validate_numericality_of(:weight_after).is_greater_than_or_equal_to(0.0).allow_nil }
  end

  describe '.new_with_defaults' do
    let(:user) { FactoryGirl.build(:user) }
    let(:workout) { described_class.new_with_defaults(user) }
    it 'returns a new instance with some values set' do
      expect(workout).to be_new_record
      expect(workout).to be_valid
      expect(workout.kind).to eq('cycling')
      expect(workout.scheduled_on).to eq(Time.zone.today)
      expect(workout.user).to eq(user)
    end
  end

end
