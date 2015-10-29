require 'rails_helper'

RSpec.describe WorkoutStravaUpdaterService do

  describe '.new' do
    let(:workout) { instance_double(Workout) }
    let(:activity) { mock_strava_activity }
    subject { described_class.new(workout, activity) }
    it 'returns a new instance with attributes set' do
      expect(subject.workout).to eq(workout)
      expect(subject.activity).to eq(activity)
    end
  end

  context 'validation' do
    let(:workout) { instance_double(Workout, kind: 'cycling') }
    it 'requires the activity type to match the workout kind' do
      expect(described_class.new(workout, mock_strava_activity(type: 'Run'))).to_not be_valid
      expect(described_class.new(workout, mock_strava_activity(type: 'Ride'))).to be_valid
    end
    it 'sets the errors attribute when invalid' do
      updater = described_class.new(workout, mock_strava_activity(type: 'Run'))
      updater.valid?
      expect(updater.errors).to_not be_nil
      expect(updater.errors.messages).to_not be_empty
    end
  end

  describe '#update_workout' do
    subject { described_class.new(workout, activity) }
    context 'when valid' do
      let(:user) { FactoryGirl.create(:user, time_zone: 'Brasilia', locale: 'pt') }
      let(:workout) { FactoryGirl.create(:workout, user: user, kind: 'cycling', scheduled_on: '2015-10-26') }
      let(:activity) { mock_strava_activity(type: 'Ride') }
      it 'changes the workout with the data from strava and sets the workout as done' do
        expect(subject.update_workout).to be_truthy
        workout.reload
        expect(workout.name).to eq('12/12/2012 San Francisco')
        expect(workout.observations).to eq('the best ride ever')
        expect(workout.occurred_on).to eq(Date.new(2015,10,26)) # because of time zone
        expect(workout.distance).to eq(28688.1)
        expect(workout.elapsed_time).to eq(6303)
        expect(workout.moving_time).to eq(5784)
        expect(workout.speed_avg).to eq(17.856) # 4.96 m/s
        expect(workout.speed_max).to eq(49.68) # 13.8 m/s
        expect(workout.cadence_avg).to eq(69)
        expect(workout.calories).to eq(390)
        expect(workout.elevation_gain).to eq(853.0)
        expect(workout.temperature_avg).to eq(23.0)
        expect(workout.watts_avg).to eq(136.4)
        expect(workout.heart_rate_avg).to eq(150)
        expect(workout.heart_rate_max).to eq(182)
      end
      it 'saves the raw activity data to the workout' do
        expect(workout.strava_data).to be_empty
        expect(subject.update_workout).to be_truthy
        expect(workout.strava_data).to_not be_empty
        expect(workout.strava_data).to eq(activity)
      end
      it 'preserves name and observations if set' do
        workout.name = 'previous name'
        workout.observations = 'previous observations'
        expect(subject.update_workout).to be_truthy
        workout.reload
        expect(workout.name).to eq('previous name')
        expect(workout.observations).to eq('previous observations')
      end
      it 'saves the workout' do
        expect(workout).to receive(:save!).and_return(true)
        expect(subject.update_workout).to be_truthy
      end
    end
    context 'when invalid' do
      let(:workout) { FactoryGirl.build(:workout, kind: 'cycling') }
      let(:activity) { mock_strava_activity(type: 'Run') }
      it 'returns false' do
        expect(subject.update_workout).to be_falsy
      end
      it 'does not change the workout' do
        expect(workout).to_not receive(:save)
        subject.update_workout
        expect(workout.occurred_on).to be_nil
      end
    end
  end

  def mock_strava_activity(overrides={})
    {
      id: 421201541,
      resource_state: 2,
      external_id: "garmin_push_939552911",
      upload_id: 471162968,
      athlete: {id: 2871350, resource_state: 1},
      name: "12/12/2012 San Francisco",
      description: "the best ride ever",
      distance: 28688.1,
      moving_time: 5784,
      elapsed_time: 6303,
      total_elevation_gain: 853.0,
      type: "Ride",
      start_date: "2015-10-27T01:07:55Z",
      start_date_local: "2015-10-26T23:07:55Z",
      timezone: "(GMT-03:00) America/Sao_Paulo",
      start_latlng: [-22.962627, -43.217705],
      end_latlng: [-22.962734, -43.217789],
      location_city: "Rio de Janeiro",
      location_state: "Rio de Janeiro",
      location_country: "Brazil",
      start_latitude: -22.962627,
      start_longitude: -43.217705,
      achievement_count: 18,
      kudos_count: 15,
      comment_count: 0,
      athlete_count: 4,
      photo_count: 0,
      trainer: false,
      commute: false,
      manual: false,
      private: false,
      flagged: false,
      gear_id: "b1234276",
      average_speed: 4.96,
      max_speed: 13.8,
      calories: 390.5,
      average_cadence: 69.2,
      average_temp: 23.0,
      average_watts: 136.4,
      kilojoules: 788.7,
      device_watts: false,
      average_heartrate: 150.0,
      max_heartrate: 182.0,
      total_photo_count: 0,
      has_kudoed: false,
      map: {
        id: "a421201541",
        summary_polyline: "...",
        resource_state: 2
      },
    }.merge(overrides).with_indifferent_access
  end

end
