module TestHelpers
  def login_as(user)
    if user && user.class == User && user.id.nil?
      allow(user).to receive(:id).and_return(42)
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

