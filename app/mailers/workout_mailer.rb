class WorkoutMailer < ApplicationMailer

  # TODO spec
  def share(workout, recipient)
    @workout = WorkoutPresenter.new(workout)
    @user = @workout.user
    @recipient = recipient
    I18n.with_locale(@user.locale) do
      @date = l((@workout.occurred_on || @workout.scheduled_on), format: :calendar)
      @kind = Workout.human_attribute_name("kind.#{@workout.kind}").downcase
      mail(
        to: @recipient,
        reply_to: @user.email,
        subject: t('.subject',
          kind: @kind,
          date: @date,
          user_name: @user.name,
          workout_name: @workout.name,
        )
      )
    end
  end
end
