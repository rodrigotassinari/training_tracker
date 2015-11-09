module WorkoutsChecker
  extend ActiveSupport::Concern

  included do
    private

    # before_action
    def check_if_workout_is_async_updating
      redirect_to(workout_path(@workout), alert: t('workout_shares.new.async_updating')) if @workout.async_updating?
      false
    end

  end

end
