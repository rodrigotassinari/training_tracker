require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #edit' do
    context 'with visitor' do
      it 'requires login' do
        logout
        get :edit
        expect(flash[:alert]).to eq(%{You need to <a href="/auth/strava" class="alert-link">sign in</a> to access this resource.})
        expect(response).to redirect_to(root_path)
      end
    end
    context 'logged in' do
      before do
        login_as(user)
      end
      context 'complete user' do
        let(:user) { FactoryGirl.build(:user) }
        it 'returns a sucessful response' do
          get :edit
          expect(response).to be_success
          expect(response).to render_template(:edit)
        end
      end
      context 'incomplete user' do
        let(:user) { FactoryGirl.build(:user, email: nil) }
        it 'returns a sucessful response' do
          get :edit
          expect(response).to be_success
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:user_params) { {name: 'New name', email: 'new@email.com', locale: 'pt', time_zone: 'Brasilia'} }
    context 'with visitor' do
      it 'requires login' do
        logout
        put :update, user: user_params
        expect(flash[:alert]).to eq(%{You need to <a href="/auth/strava" class="alert-link">sign in</a> to access this resource.})
        expect(response).to redirect_to(root_path)
      end
    end
    context 'logged in' do
      let(:user) { FactoryGirl.build(:user) }
      before do
        login_as(user)
      end
      context 'with valid params' do
        it 'updates the user attributes and redirects' do
          expect(user).to receive(:update).with(user_params).and_return(true)
          put :update, user: user_params
          expect(flash[:notice]).to eq("Profile successfully updated.")
          expect(response).to redirect_to(root_path)
        end
        context 'incomplete user' do
          let(:user) { FactoryGirl.build(:incomplete_user, email: nil) }
          it 'updates the user attributes and redirects' do
            expect(user).to receive(:update).with(user_params).and_return(true)
            put :update, user: user_params
            expect(flash[:notice]).to eq("Profile successfully updated.")
            expect(response).to redirect_to(root_path)
          end
        end
      end
      context 'with invalid params' do
        it 'renders the edit template' do
          expect(user).to receive(:update).with(user_params).and_return(false)
          put :update, user: user_params
          expect(response).to render_template(:edit)
        end
        it 'requires an user param' do
          expect { put :update }.
            to raise_error(ActionController::ParameterMissing)
        end
        it 'protects against mass-assignment' do
          expect(user).to receive(:update).with(user_params).and_return(true)
          put :update, user: user_params.merge(id: 24, created_at: Time.zone.now)
        end
      end
    end
  end

end
