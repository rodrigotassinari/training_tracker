class Workout < ActiveRecord::Base

  KINDS = %w(cycling running swimming)

  serialize :strava_data, JsonbHashSerializer
  serialize :garmin_connect_data, JsonbHashSerializer

  belongs_to :user

  validates :user, presence: true
  validates :kind, presence: true, inclusion: {in: KINDS}
  validates :scheduled_on, presence: true
  validates :public_access_token, presence: true, uniqueness: true
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
  # TODO validate (and normalize?) strava_url format
  # TODO validate (and normalize?) garmin_connect_url format

  before_validation :generate_public_access_token, on: [:create]
  before_save :clear_strava_data

  def self.new_with_defaults(user)
    new(kind: 'cycling', scheduled_on: Time.zone.today, user: user)
  end

  scope :todo, -> { where(occurred_on: nil) }
  scope :done, -> { where.not(occurred_on: nil) }

  # TODO spec
  def done?
    occurred_on.present?
  end

  scope :future, -> { where('scheduled_on >= ?', Time.zone.today) }

  # TODO spec
  def future?
    scheduled_on >= Time.zone.today
  end

  scope :past, -> { where('scheduled_on < ?', Time.zone.today) }

  # TODO spec
  def past?
    scheduled_on < Time.zone.today
  end

  scope :late, -> { past.todo }

  # TODO spec
  def late?
    past? && !done?
  end

  scope :today, -> { where('scheduled_on = ?', Time.zone.today) }

  # TODO spec
  def today?
    scheduled_on == Time.zone.today
  end

  scope :latest, -> { order(scheduled_on: :desc, created_at: :desc).limit(1) }

  # TODO spec
  def distance_in_km
    return if distance.blank?
    distance / 1000.0
  end

  # TODO spec
  def distance_in_km=(value)
    distance = value * 1000.0
  end

  # TODO spec
  def elapsed_time_in_hours
    return if elapsed_time.blank?
    ChronicDuration.output(elapsed_time,
      format: :chrono, limit_to_hours: true)
  end

  # TODO spec
  def elapsed_time_in_hours=(hour_string)
    self.elapsed_time = (hour_string.blank? ? nil : ChronicDuration.parse(hour_string))
  end

  # TODO spec
  def moving_time_in_hours
    return if moving_time.blank?
    ChronicDuration.output(moving_time,
      format: :chrono, limit_to_hours: true)
  end

  # TODO spec
  def moving_time_in_hours=(hour_string)
    self.moving_time = (hour_string.blank? ? nil : ChronicDuration.parse(hour_string))
  end

  # TODO spec
  def has_strava?
    !strava_url.blank? &&
      !strava_data.empty? &&
      strava_data[:id].present?
  end

  # TODO spec
  def fetching_strava_data?
    !strava_url.blank? && strava_data.empty?
  end
  alias :needs_strava_data? :fetching_strava_data?

  # TODO spec
  def has_garmin_connect?
    !garmin_connect_url.blank?
  end

  # TODO spec
  def async_updating?
    fetching_strava_data?
  end

  # TODO spec
  def undo
    [:occurred_on, :observations, :coach_observations, :weight_before,
      :weight_after, :distance, :elapsed_time, :moving_time, :speed_avg,
      :speed_max, :cadence_avg, :cadence_max, :calories, :elevation_gain,
      :temperature_avg, :temperature_max, :temperature_min, :watts_avg,
      :watts_weighted_avg, :watts_max, :heart_rate_avg, :heart_rate_max,
      :strava_url, :garmin_connect_url].each do |attr|
      self.send("#{attr}=", nil)
    end
    [:strava_data, :garmin_connect_data].each do |attr|
      self.send("#{attr}=", {})
    end
    save
  end

  # TODO spec
  def fetch_strava_data!
    StravaDataFetcherJob.perform_later(self.id)
  end

  private

  # before_save
  def clear_strava_data
    if self.strava_url_changed? && !self.strava_data_changed?
      self.strava_data = {}
    end
  end

  # before_validation on: create
  def generate_public_access_token
    self.public_access_token ||= SecureRandom.urlsafe_base64(24)
  end

end
