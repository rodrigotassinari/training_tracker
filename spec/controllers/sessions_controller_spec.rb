require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe 'GET #create' do
    let(:auth_hash) { {'some' => 'omniauth', 'test' => 'values'} }
    let(:user) { instance_double('User',
      id: 42, name: 'John Doe', just_created?: false,
      time_zone: 'UTC', locale: 'en', complete?: true,
      remember_me_token: 'some-unique-token-42') }
    before do
      @request.env['omniauth.auth'] = auth_hash
    end
    it 'signs in the user' do
      expect(User).to receive(:find_or_create_from_auth_hash!).
        with(auth_hash).and_return(user)
      expect(session[:user_token]).to be_nil
      expect(subject.send(:current_user)).to be_nil
      get :create, provider: 'strava'
      expect(session[:user_token]).to eq(user.remember_me_token)
      expect(subject.send(:current_user)).to eq(user)
    end
    context 'when the user already exists' do
      before do
        allow(User).to receive(:find_or_create_from_auth_hash!).and_return(user)
      end
      it 'responds successfully with an HTTP 302 status code' do
        expect(user).to receive(:just_created?).and_return(false)
        get :create, provider: 'strava'
        expect(flash[:notice]).to eq("Welcome back, #{user.name}!")
        expect(response).to redirect_to(workouts_path)
      end
    end
    context 'when the user was just created' do
      before do
        allow(User).to receive(:find_or_create_from_auth_hash!).and_return(user)
      end
      it 'responds successfully with an HTTP 302 status code' do
        expect(user).to receive(:just_created?).and_return(true)
        get :create, provider: 'strava'
        expect(flash[:notice]).to eq("Thank you for signing up. Please take a moment to complete your profile.")
        expect(response).to redirect_to(edit_user_path)
      end
    end
  end

  describe 'GET #destroy' do
    let(:user) { instance_double('User', id: 42, time_zone: 'UTC',
      locale: 'en', complete?: true, remember_me_token: 'some-unique-token-42') }
    before do
      login_as(user)
    end
    it 'signs out the current user' do
      expect(session[:user_token]).to eq(user.remember_me_token)
      expect(subject.send(:current_user)).to eq(user)
      get :destroy
      expect(session[:user_token]).to be_nil
      expect(subject.send(:current_user)).to be_nil
    end
    it 'redirects to the root path with a message' do
      get :destroy
      expect(flash[:notice]).to eq("Successfully logged out.")
      expect(response).to redirect_to(root_path)
    end
  end

end
