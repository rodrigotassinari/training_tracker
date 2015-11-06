require "rails_helper"

RSpec.describe WorkoutMailer, type: :mailer do
  let(:workout) { FactoryGirl.create(:workout) }

  describe "share" do
    let(:mail) { WorkoutMailer.share(workout, 'john@example.com') }

    # it "renders the headers" do
    #   expect(mail.subject).to eq("TODO")
    #   expect(mail.to).to eq(["to@example.org"])
    #   expect(mail.from).to eq(["from@example.com"])
    # end

    # it "renders the body" do
    #   expect(mail.body.encoded).to match("Hi")
    # end
  end

end
