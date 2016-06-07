require 'rails_helper'

RSpec.describe WorkoutPresenter, type: :model do

  context "markdown-enabled fields" do
    let(:input) { %{hello **world**!} }
    let(:output) { %{<p>hello <strong>world</strong>!</p>\n} }

    let(:workout) {
      FactoryGirl.build(:workout,
        description: input, observations: input, coach_observations: input)
    }
    subject { described_class.new(workout) }

    it 'returns unformatted description' do
      expect(subject.description).to eq(input)
    end
    it 'returns formatted description' do
      expect(subject.formatted_description).to eq(output)
    end
    it 'returns unformatted observations' do
      expect(subject.observations).to eq(input)
    end
    it 'returns formatted observations' do
      expect(subject.formatted_observations).to eq(output)
    end
    it 'returns unformatted coach_observations' do
      expect(subject.coach_observations).to eq(input)
    end
    it 'returns formatted coach_observations' do
      expect(subject.formatted_coach_observations).to eq(output)
    end
  end

end
