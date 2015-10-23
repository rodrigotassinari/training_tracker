require 'rails_helper'

RSpec.describe WorkoutFinderService do

  describe '.new' do
    let(:user) { instance_double(User) }
    subject { described_class.new(user) }
    it 'instanciates a new object with a user attribute' do
      expect(subject.user).to eq(user)
    end
  end

  describe '#find' do
    let(:user) { FactoryGirl.create(:user) }
    let(:workout) { FactoryGirl.create(:workout, user: user) }
    let(:other_workout) { FactoryGirl.create(:workout) }
    subject { described_class.new(user) }
    it 'raises an error if the workout does not exist' do
      expect { subject.find('some-uuid') }.
        to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'returns the user workout' do
      expect(subject.find(workout.id)).to eq(workout)
    end
    it 'does not find another user workout' do
      expect { subject.find(other_workout.id) }.
        to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#most_recents' do
    let(:user) { FactoryGirl.create(:user) }
    let(:workout1) { FactoryGirl.create(:workout, user: user, scheduled_on: Time.zone.today) }
    let(:workout2) { FactoryGirl.create(:workout, user: user, scheduled_on: Time.zone.tomorrow) }
    let(:other_workout) { FactoryGirl.create(:workout, scheduled_on: Time.zone.tomorrow) }
    subject { described_class.new(user) }
    it 'returns a list of the user workouts, ordered' do
      expect(subject.most_recents).to eq([workout2, workout1])
    end
    it 'does not find other user workouts' do
      expect(subject.most_recents).to_not include(other_workout)
    end
    it 'returns an empty list if no workouts exist for the user' do
      expect(subject.most_recents).to be_empty
    end
  end

end
