RSpec.shared_examples 'authentication requirement' do
  it 'requires the user to be logged in' do
    logout
    action.call
    expect(flash[:alert]).to eq(
      %{You need to <a href="/auth/strava" class="alert-link">sign in</a> to access this resource.})
    expect(response).to redirect_to(root_path)
  end
end

RSpec.shared_examples 'complete user requirement' do
  it 'requires the user to be complete' do
    login_as(FactoryGirl.build(:user, email: nil))
    action.call
    expect(flash[:notice]).to eq(
      "Please complete your profile information.")
    expect(response).to redirect_to(edit_user_path)
  end
end
