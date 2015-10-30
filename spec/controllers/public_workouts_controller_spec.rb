require 'rails_helper'

RSpec.describe PublicWorkoutsController, type: :controller do

  describe 'GET #show' do
    it 'finds the workout by token'
    it 'shows a 404 page if workout not found'
    it 'renders a public view response'
    it 'is accessible by logged in users'
    it 'is accessible by visitors'
    it 'selects locale from visitor browser'
    it 'guesses time_zone from visitor locale'
  end

end
