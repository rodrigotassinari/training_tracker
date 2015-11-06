require 'rails_helper'

describe WorkoutShare do
  let(:workout) { FactoryGirl.create(:workout) }

  context 'validations' do
    subject { described_class.new(workout: workout, emails: 'foo@bar.com') }
    it { is_expected.to validate_presence_of(:workout) }
    it { is_expected.to validate_presence_of(:emails) }
    it { is_expected.to allow_value('foo@bar.com').for(:emails) }
    it { is_expected.to allow_value('foo@bar.com, ').for(:emails) }
    it { is_expected.to allow_value('foo@bar.com, spam@eggs.org').for(:emails) }
    it { is_expected.to_not allow_value('foo').for(:emails) }
    it { is_expected.to_not allow_value('foo@').for(:emails) }
    it { is_expected.to_not allow_value('foo@bar.com, spam').for(:emails) }
    it { is_expected.to_not allow_value(', foo@bar.com').for(:emails) }
  end

  describe '#send_emails' do
    # TODO
  end

end
