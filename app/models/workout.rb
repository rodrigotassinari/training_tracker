class Workout < ActiveRecord::Base

  KINDS = %w(cycling running swimming)

  belongs_to :user

  validates :user, presence: true
  validates :kind, presence: true, inclusion: {in: KINDS}
  validates :scheduled_on, presence: true
  validates :elapsed_time, numericality: {
    greater_than_or_equal_to: 0, only_integer: true, allow_nil: true}
  validates :moving_time, numericality: {
    greater_than_or_equal_to: 0, only_integer: true, allow_nil: true}
  validates :cadence_avg, numericality: {
    greater_than_or_equal_to: 0, only_integer: true, allow_nil: true}
  validates :cadence_max, numericality: {
    greater_than_or_equal_to: 0, only_integer: true, allow_nil: true}
  validates :calories, numericality: {
    greater_than_or_equal_to: 0, only_integer: true, allow_nil: true}
  validates :heart_rate_avg, numericality: {
    greater_than_or_equal_to: 0, only_integer: true, allow_nil: true}
  validates :heart_rate_max, numericality: {
    greater_than_or_equal_to: 0, only_integer: true, allow_nil: true}
  validates :distance, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :speed_avg, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :speed_max, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :elevation_gain, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :temperature_avg, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :temperature_max, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :temperature_min, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :watts_avg, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :watts_weighted_avg, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :watts_max, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :weight_before, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}
  validates :weight_after, numericality: {
    greater_than_or_equal_to: 0.0, allow_nil: true}

  # TODO spec
  def done?
    occurred_on.present?
  end

  # TODO spec
  def future?
    scheduled_on >= Time.zone.today
  end

  # TODO spec
  def past?
    scheduled_on < Time.zone.today
  end

  # TODO spec
  def late?
    past? && !done?
  end

  # TODO spec
  def today?
    scheduled_on == Time.zone.today
  end

end
