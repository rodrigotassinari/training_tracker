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

  describe 'GET #new' do
    let(:user) { FactoryGirl.build(:user) }
    include_examples 'authentication requirement' do
      let(:action) {-> {get :new}}
    end
    include_examples 'complete user requirement' do
      let(:action) {-> {get :new}}
    end
    context 'logged in and complete' do
      before do
        login_as(user)
      end
      it 'returns a success response' do
        get :new
        expect(response).to be_success
        expect(response).to render_template(:new)
      end
      it 'assigns a new workout' do
        expect(Workout).to receive(:new_with_defaults).
          with(user).
          and_return(workout = instance_double(Workout))
        get :new
        expect(assigns(:workout)).to eq(workout)
      end
    end
  end

  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }
    # let(:workout_attributes) { {kind: 'cycling', "scheduled_on(3i)"=>"27", "scheduled_on(2i)"=>"10", "scheduled_on(1i)"=>"2015", name: 'some workout'} }
    # let(:workout_attributes) { {kind: 'cycling', scheduled_on: Time.zone.today.to_s, name: 'some workout'} }
    let(:workout_attributes) { {kind: 'cycling', name: 'some workout'} }
    include_examples 'authentication requirement' do
      let(:action) {-> {post :create, workout: workout_attributes}}
    end
    include_examples 'complete user requirement' do
      let(:action) {-> {post :create, workout: workout_attributes}}
    end
    context 'delocalize' do
      before do
        login_as(user)
      end
      let!(:delocalized_attributes) { {scheduled_on: Time.zone.today, weight_before: '87.65', cadence_avg: '85', calories: '1234', elevation_gain: '1234.56', distance: '6543.21'} }
      context 'user uses english' do
        let(:user) { FactoryGirl.create(:user, locale: 'en') }
        it 'delocalizes attributes when en' do
          localized_attributes = {scheduled_on: Time.zone.today.strftime('%m/%d/%Y'), weight_before: '87.65', cadence_avg: '85', calories: '1,234', elevation_gain: '1,234.56', distance: '6543.21'}
          expect(Workout).to receive(:new).
            with(workout_attributes.merge(delocalized_attributes)).
            and_return(FactoryGirl.build(:workout, user: user))
          I18n.with_locale(:en) do
            post :create, workout: workout_attributes.merge(localized_attributes)
          end
        end
      end
      context 'user uses portuguese' do
        let(:user) { FactoryGirl.create(:user, locale: 'pt') }
        it 'delocalizes attributes when pt' do
          localized_attributes = {scheduled_on: Time.zone.today.strftime('%d/%m/%Y'), weight_before: '87,65', cadence_avg: '85', calories: '1.234', elevation_gain: '1.234,56', distance: '6543,21'}
          expect(Workout).to receive(:new).
            with(workout_attributes.merge(delocalized_attributes)).
            and_return(FactoryGirl.build(:workout, user: user))
          I18n.with_locale(:pt) do
            post :create, workout: workout_attributes.merge(localized_attributes)
          end
        end
      end
    end
    # context 'logged in and complete' do
    #   before do
    #     login_as(user)
    #   end
    #   it 'creates a workout'
    # end
  end

end
