require 'rails_helper'

RSpec.describe WorkoutsController, type: :controller do

  describe 'GET #index' do
    include_examples 'authentication requirement' do
      let(:action) {-> {get :index}}
    end
    include_examples 'complete user requirement' do
      let(:action) {-> {get :index}}
    end
    context 'logged in and complete' do
      let(:user) { FactoryGirl.build(:user) }
      let(:workout) { FactoryGirl.build(:workout, user: user) }
      before do
        login_as(user)
      end
      it 'returns http success' do
        get :index
        expect(response).to be_success
        expect(response).to render_template(:index)
      end
      it 'assigns the recent user workouts' do
        expect(WorkoutFinderService).
          to receive(:new).with(user).
          and_return(finder = instance_double(WorkoutFinderService))
        expect(finder).to receive(:most_recents).and_return([workout])
        get :index
        expect(assigns(:workouts)).to eq([workout])
      end
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryGirl.build(:user) }
    let(:workout) { instance_double(Workout, user: user, id: 42) }
    include_examples 'authentication requirement' do
      let(:action) {-> {get :show, id: workout.id}}
    end
    include_examples 'complete user requirement' do
      let(:action) {-> {get :show, id: workout.id}}
    end
    context 'logged in and complete' do
      before do
        login_as(user)
        allow_any_instance_of(WorkoutFinderService).
          to receive(:find).and_return(workout)
      end
      it 'returns http success' do
        get :show, id: workout.id
        expect(response).to be_success
        expect(response).to render_template(:show)
      end
      it 'assigns the user workout' do
        expect(WorkoutFinderService).
          to receive(:new).with(user).
          and_return(finder = instance_double(WorkoutFinderService))
        expect(finder).to receive(:find).
          with(workout.id.to_s).and_return(workout)
        get :show, id: workout.id
        expect(assigns(:workout)).to eq(workout)
      end
    end
  end

end
