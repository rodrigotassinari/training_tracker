require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #create" do
    it "responds successfully with an HTTP 302 status code" do
      get :create
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
      # TODO header location = ?
    end

    it "redirects to the root path" do
      get :create
      expect(response).to redirect_to(root_path)
    end

    it "signs in the user"
  end

  describe "GET #destroy" do
    it "signs out the current user"

    it "redirects to the root path" do
      get :destroy
      expect(response).to redirect_to(root_path)
    end
  end

end
