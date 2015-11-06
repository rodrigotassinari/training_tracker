class WorkoutMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.workout_mailer.share.subject
  #
  def share(workout, recipient)
    @workout = workout
    @greeting = "Hi"

    mail(to: recipient, subject: 'TODO')
  end
end
