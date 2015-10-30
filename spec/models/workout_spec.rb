require 'rails_helper'

RSpec.describe Workout, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    subject { FactoryGirl.build(:workout) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:kind) }
    # it { is_expected.to validate_presence_of(:public_access_token) } # can't test this because it is auto-generated
    it { is_expected.to validate_uniqueness_of(:public_access_token) }
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

  describe 'public_access_token' do
    it 'sets a random value on creation' do
      w1 = FactoryGirl.build(:workout)
      w2 = FactoryGirl.build(:workout)
      expect(w1.public_access_token).to be_blank
      expect(w2.public_access_token).to be_blank
      expect(w1).to be_valid
      expect(w2).to be_valid
      expect(w1.public_access_token).to_not be_blank
      expect(w2.public_access_token).to_not be_blank
      expect(w1.public_access_token).to_not eq(w2.public_access_token)
    end
    it 'does not change the value on update' do
      workout = FactoryGirl.create(:workout)
      token = workout.public_access_token
      expect(token).to_not be_blank
      workout.save!
      workout.reload
      expect(workout.public_access_token).to eq(token)
    end
  end

  describe 'strava_data clearing' do
    let(:activity_url) { 'https://www.strava.com/activities/421201541' }
    let(:other_activity_url) { 'https://www.strava.com/activities/398432511' }
    context 'on workout create' do
      context 'normal create' do
        subject { FactoryGirl.build(:workout) }
        it 'does nothing' do
          expect(subject.strava_data).to be_empty
          subject.save!
          expect(subject.strava_data).to be_empty
          expect(subject.needs_strava_data?).to be_falsy
        end
      end
      context 'creation with strava_url' do
        subject { FactoryGirl.build(:workout, strava_url: activity_url) }
        it 'does nothing' do
          expect(subject.strava_data).to be_empty
          subject.save!
          expect(subject.strava_data).to be_empty
          expect(subject.needs_strava_data?).to be_truthy
        end
      end
    end
    context 'on workout update' do
      context 'normal update' do
        subject { FactoryGirl.create(:workout) }
        it 'does nothing' do
          expect(subject.strava_data).to be_empty
          subject.update!(description: 'some description')
          expect(subject.strava_data).to be_empty
          expect(subject.needs_strava_data?).to be_falsy
        end
      end
      context 'normal update of done workout' do
        subject { FactoryGirl.create(:done_workout) }
        it 'does nothing' do
          expect(subject.strava_data).to_not be_empty
          subject.update!(description: 'some description')
          expect(subject.strava_data).to_not be_empty
          expect(subject.needs_strava_data?).to be_falsy
        end
      end
      context 'adding strava_url' do
        subject { FactoryGirl.create(:workout) }
        it 'enqueues strava data fetch' do
          expect(subject.strava_data).to be_empty
          subject.update!(description: 'some description', strava_url: activity_url)
          expect(subject.strava_data).to be_empty
          expect(subject.needs_strava_data?).to be_truthy
        end
      end
      context 'replacing strava_url' do
        subject { FactoryGirl.create(:done_workout, strava_url: activity_url) }
        it 'enqueues strava data fetch' do
          expect(subject.strava_data).to_not be_empty
          subject.update!(description: 'some description', strava_url: other_activity_url)
          expect(subject.strava_data).to be_empty
          expect(subject.needs_strava_data?).to be_truthy
        end
      end
      context 're-using strava_url' do
        subject { FactoryGirl.create(:done_workout, strava_url: activity_url) }
        it 'does nothing' do
          expect(subject.strava_data).to_not be_empty
          subject.update!(description: 'some description', strava_url: activity_url)
          expect(subject.strava_data).to_not be_empty
          expect(subject.needs_strava_data?).to be_falsy
        end
      end
    end
  end

end
