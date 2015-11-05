module TestHelpers
  def login_as(user)
    if user && user.class == User && user.remember_me_token.nil?
      allow(user).to receive(:remember_me_token).and_return(42)
    end
    controller.send(:current_user=, user)
  end

  def logout
    login_as(nil)
  end
end

RSpec.configure do |c|
  c.include TestHelpers
end
