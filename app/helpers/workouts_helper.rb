module WorkoutsHelper

  # TODO spec
  def workout_summary_panel_style(workout)
    return 'panel-info' if workout.done?
    return 'panel-primary' if workout.today?
    return 'panel-warning' if workout.late?
    'panel-default'
  end

  # TODO spec
  def workout_kind_image_tag(workout)
    image_tag("workout_#{workout.kind}.png", alt: workout.kind, height: 18)
  end

end
