require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do

  describe 'omniauth_login_path' do
    it 'returns a path to the auth page of the given provider' do
      expect(helper.omniauth_login_path(:foobar)).to eq('/auth/foobar')
    end
  end

  describe 'strava_login_path' do
    it 'returns a path to the auth page of the strava provider' do
      expect(helper.strava_login_path).to eq('/auth/strava')
    end
  end

end
