class WorkoutPresenter < Burgundy::Item

  def self.validators_on(args)
    Workout.validators_on(args)
  end

  def weight_before
    helpers.number_with_delimiter(item.weight_before)
  end

  def weight_after
    helpers.number_with_delimiter(item.weight_after)
  end

  def distance
    helpers.number_with_delimiter(item.distance)
  end

  def speed_avg
    helpers.number_with_delimiter(item.speed_avg)
  end

  def speed_max
    helpers.number_with_delimiter(item.speed_max)
  end

  def cadence_avg
    helpers.number_with_delimiter(item.cadence_avg)
  end

  def cadence_max
    helpers.number_with_delimiter(item.cadence_max)
  end

  def calories
    helpers.number_with_delimiter(item.calories)
  end

  def elevation_gain
    helpers.number_with_delimiter(item.elevation_gain)
  end

  def temperature_avg
    helpers.number_with_delimiter(item.temperature_avg)
  end

  def temperature_max
    helpers.number_with_delimiter(item.temperature_max)
  end

  def temperature_min
    helpers.number_with_delimiter(item.temperature_min)
  end

  def watts_avg
    helpers.number_with_delimiter(item.watts_avg)
  end

  def watts_weighted_avg
    helpers.number_with_delimiter(item.watts_weighted_avg)
  end

  def watts_max
    helpers.number_with_delimiter(item.watts_max)
  end

  def heart_rate_avg
    helpers.number_with_delimiter(item.heart_rate_avg)
  end

  def heart_rate_max
    helpers.number_with_delimiter(item.heart_rate_max)
  end

end
