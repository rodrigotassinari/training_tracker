require 'rails_helper'

RSpec.describe "users/edit.html.erb", type: :view do
  let(:user) { FactoryGirl.build(:user) }
  before do
    view.define_singleton_method(:current_user) { nil }
    allow(view).to receive(:current_user).and_return(user)
  end
  it 'renders a user edit form' do
    render
    assert_select "form[action=?]", "/user" do
      assert_select 'input[type=hidden][name=_method][value=put]', 1
      assert_select 'input[type=text][name=?][value=?]', 'user[name]', user.name
      assert_select 'input[type=email][name=?][value=?]', 'user[email]', user.email
      assert_select 'select[name=?]', 'user[locale]' do
        assert_select 'option[selected][value=?]', user.locale
      end
      assert_select 'select[name=?]', 'user[time_zone]' do
        assert_select 'option[selected][value=?]', user.time_zone
      end
    end
    # expect(rendered).to include(user.name)
  end
end
