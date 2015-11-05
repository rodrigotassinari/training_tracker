require 'rails_helper'

RSpec.describe User, type: :model do

  context 'associations' do
    it { is_expected.to have_many(:identities).dependent(:destroy) }
    it { is_expected.to have_many(:workouts).dependent(:destroy) }
  end

  context 'validations' do
    subject { FactoryGirl.build(:user, remember_me_token: SecureRandom.urlsafe_base64(24)) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:locale) }
    it { is_expected.to validate_presence_of(:time_zone) }
    it { is_expected.to validate_uniqueness_of(:email).
          case_insensitive.allow_blank }
    it { is_expected.to validate_inclusion_of(:locale).
          in_array(I18n.available_locales.map(&:to_s)) }
    it { is_expected.to validate_inclusion_of(:time_zone).
          in_array(ActiveSupport::TimeZone::MAPPING.keys) }
    # it { is_expected.to validate_presence_of(:remember_me_token) } # can't test this because it is auto-generated
    it { is_expected.to validate_uniqueness_of(:remember_me_token) }
  end

  describe 'remember_me_token' do
    it 'sets a random value on creation' do
      u1 = FactoryGirl.build(:user)
      u2 = FactoryGirl.build(:user)
      expect(u1.remember_me_token).to be_blank
      expect(u2.remember_me_token).to be_blank
      expect(u1).to be_valid
      expect(u2).to be_valid
      expect(u1.remember_me_token).to_not be_blank
      expect(u2.remember_me_token).to_not be_blank
      expect(u1.remember_me_token).to_not eq(u2.remember_me_token)
    end
    it 'does not change the value on update' do
      user = FactoryGirl.create(:user)
      token = user.remember_me_token
      expect(token).to_not be_blank
      user.save!
      user.reload
      expect(user.remember_me_token).to eq(token)
    end
  end

  describe '#complete?' do
    subject { FactoryGirl.build(:user) }
    it 'returns true if all main fields are present' do
      expect(subject).to be_complete
    end
    it 'returns false if any main field is blank' do
      subject.email = ''
      expect(subject).to_not be_complete
    end
  end

  describe '#just_created?' do
    subject { FactoryGirl.build(:user) }
    it 'returns false for non-persisted users' do
      expect(subject.just_created?).to be_falsy
    end
    it 'returns true if the user has recently been created and not changed' do
      subject.save!
      expect(subject.just_created?).to be_truthy
    end
    it 'returns false if the user has been changed since creation' do
      subject.save!
      subject.update_attributes(name: 'Another Guy')
      expect(subject.just_created?).to be_falsy
    end
  end

  describe '.find_or_create_from_auth_hash!' do
    let(:auth_hash) { {'some' => 'values'} }
    let(:user) { FactoryGirl.build(:user) }
    context 'when the user already exists' do
      it 'returns the existing user' do
        expect(User).to receive(:find_from_auth_hash).
          with(auth_hash).and_return(user)
        returned_user = described_class.find_or_create_from_auth_hash!(auth_hash)
        expect(returned_user).to eq(user)
      end
    end
    context 'when the user does not exist yet' do
      before do
        expect(User).to receive(:find_from_auth_hash).
          with(auth_hash).and_return(nil)
      end
      it 'creates an user and returns it' do
        expect(User).to receive(:create_from_auth_hash!).
          with(auth_hash).and_return(user)
        returned_user = described_class.find_or_create_from_auth_hash!(auth_hash)
        expect(returned_user).to eq(user)
      end
      it 'raises an erro if it can not create the user' do
        expect(User).to receive(:create_from_auth_hash!).
          with(auth_hash).and_raise(RuntimeError, 'something went wrong')
        expect { described_class.find_or_create_from_auth_hash!(auth_hash) }.
          to raise_error(RuntimeError, 'something went wrong')
      end
    end
  end

  describe '.find_from_auth_hash(auth_hash)' do
    subject { FactoryGirl.create(:user_with_identity) }
    let(:identity) { subject.identities.first }
    let(:auth_hash) { {'provider' => identity.provider, 'uid' => identity.uid} }
    context 'when the user exists' do
      it 'returns the user' do
        user = described_class.find_from_auth_hash(auth_hash)
        expect(user).to eq(subject)
      end
    end
    context 'when the user does not exist yet' do
      it 'returns nil' do
        user = described_class.find_from_auth_hash(
          auth_hash.merge('uid' => 'another_uid')
        )
        expect(user).to be_nil
      end
    end
  end

  describe '.create_from_auth_hash!' do
    let(:auth_hash) {
      { 'provider' => "strava",
        'uid' => '123456',
        'info' => {"name"=>"John Doe", "email"=>"john.doe@example.com", "location"=>"New York NY", "last_name"=>"Doe", "first_name"=>"John"},
        'credentials' => {"token"=>"8a7be76f40f91c32f34ef34a129208ab0aad7d99", "expires"=>false},
        'extra' => {"raw_info"=>{"id"=>1234567, "ftp"=>nil, "sex"=>"M", "city"=>"New York", "bikes"=>[{"id"=>"b1500344", "name"=>"Old Bike", "primary"=>false, "distance"=>86716.0, "resource_state"=>2}, {"id"=>"b1234288", "name"=>"Current Bike", "primary"=>true, "distance"=>6057094.0, "resource_state"=>2}], "clubs"=>[{"id"=>12345, "name"=>"Some Club", "profile"=>"https://dgalywyr863hv.cloudfront.net/pictures/clubs/38174/1036347/4/large.jpg", "profile_medium"=>"https://dgalywyr863hv.cloudfront.net/pictures/clubs/38174/1036347/4/medium.jpg", "resource_state"=>2}], "email"=>"john.doe@example.com", "shoes"=>[{"id"=>"g199111", "name"=>"Current Shoes", "primary"=>true, "distance"=>9000.0, "resource_state"=>2}], "state"=>"NY", "friend"=>nil, "weight"=>75.0, "country"=>"USA", "premium"=>true, "profile"=>"https://dgalywyr863hv.cloudfront.net/pictures/athletes/1234567/913413/2/large.jpg", "follower"=>nil, "lastname"=>"Doe", "firstname"=>"John", "created_at"=>"2013-08-22T15:32:03Z", "updated_at"=>"2015-10-02T06:02:51Z", "athlete_type"=>0, "friend_count"=>46, "badge_type_id"=>1, "follower_count"=>45, "profile_medium"=>"https://dgalywyr863hv.cloudfront.net/pictures/athletes/1234567/913413/2/medium.jpg", "resource_state"=>3, "date_preference"=>"%d/%m/%Y", "mutual_friend_count"=>0, "measurement_preference"=>"meters"}, "all_ride_totals"=>nil, "ytd_ride_totals"=>nil, "recent_ride_totals"=>nil}
      }
    }
    it 'returns the created user' do
      user = nil
      expect { user = described_class.create_from_auth_hash!(auth_hash) }.
        to change { User.count }.by(1)
      expect(user).to_not be_nil
      expect(user).to be_instance_of(User)
      expect(user).to be_persisted
    end
    it 'creates a new user and identity with values from the auth_hash' do
      user = described_class.create_from_auth_hash!(auth_hash)
      expect(user.name).to eq("John Doe")
      expect(user.email).to eq("john.doe@example.com")
      expect(user.locale).to eq('en')
      expect(user.time_zone).to eq('UTC')
      expect(user.identities.count).to eq(1)
      identity = user.identities.first
      expect(identity.provider).to eq("strava")
      expect(identity.uid).to eq('123456')
      expect(identity.info).to eq(auth_hash['info'])
      expect(identity.credentials).to eq(auth_hash['credentials'])
      expect(identity.extra).to eq(auth_hash['extra'])
    end
    it 'raises an error if the user can not be created' do
      auth_hash['info']['name'] = ''
      expect(User.count).to eq(0)
      expect { described_class.create_from_auth_hash!(auth_hash) }.
        to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
      expect(User.count).to eq(0)
    end
  end

end
