require 'rails_helper'

RSpec.describe "users/edit.html.erb", type: :view do
  let(:user) { FactoryGirl.build(:user) }
  before do
    view.define_singleton_method(:current_user) { nil }
    allow(view).to receive(:current_user).and_return(user)
  end
  it 'renders a user edit form' do
    render
    assert_select('form')
    expect(rendered).to include(user.name)
  end
end
