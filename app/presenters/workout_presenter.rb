require_dependency 'activity_url_helpers'
require_dependency 'markdown_helper'

class WorkoutPresenter < Burgundy::Item
  include ActivityUrlHelpers
  include MarkdownHelper

  def self.validators_on(args)
    Workout.validators_on(args)
  end

  [:description, :observations, :coach_observations].each do |attr|
    define_method("formatted_#{attr}") do
      markdownify(item.send(attr))
    end
  end

  [:weight_before, :weight_after, :distance,
    :speed_avg, :speed_max, :cadence_avg, :cadence_max, :calories,
    :temperature_avg, :temperature_max, :temperature_min, :power_avg,
    :power_weighted_avg, :power_max, :energy_output, :heart_rate_avg,
    :heart_rate_max
    ].each do |attr|
    define_method(attr) do
      helpers.number_with_delimiter(item.send(attr))
    end
  end

  def distance_in_km
    helpers.number_with_precision(item.distance_in_km, precision: 1)
  end

  def elevation_gain
    helpers.number_with_precision(item.elevation_gain, precision: 0)
  end

  def user
    @user ||= UserPresenter.new(item.user)
  end

  def strava_id
    return if item.strava_url.blank?
    parse_strava_activity_id_from_url(item.strava_url)
  end

  def garmin_connect_id
    return if item.garmin_connect_url.blank?
    parse_garmin_connect_activity_id_from_url(item.garmin_connect_url)
  end

  def short_description
    [
      Workout.human_attribute_name("kind.#{item.kind}"),
      I18n.l(item.scheduled_on, format: :short_weekday),
      item.name,
    ].reject(&:blank?).join(' ')
  end

end
