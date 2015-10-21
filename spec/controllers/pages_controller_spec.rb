require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe 'GET #index' do
    context 'with visitor' do
      before do
        logout
      end
      it 'responds successfully with an HTTP 200 status code' do
        # next 2 lines to test login out (see TestHelpers#login_as)
        expect(controller.send(:current_user)).to be_nil
        expect(session[:user_id]).to be_nil
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
      it 'renders the index template' do
        get :index
        expect(response).to render_template('index')
      end
    end
    context 'with logged user' do
      let(:user) { FactoryGirl.build(:user) }
      before do
        login_as(user)
      end
      it 'responds successfully with an HTTP 200 status code' do
        # next 3 lines to test logging in with a non-persisted user record (see
        # TestHelpers#login_as)
        expect(controller.send(:current_user)).to_not be_nil
        expect(controller.send(:current_user)).to eq(user)
        expect(session[:user_id]).to eq(user.id)
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end
  end

end
