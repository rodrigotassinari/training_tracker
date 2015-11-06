# Preview all emails at http://localhost:3000/rails/mailers/workout_mailer
class WorkoutMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/workout_mailer/share
  def share
    WorkoutMailer.share
  end

end
