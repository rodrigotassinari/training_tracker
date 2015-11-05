class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy
  has_many :workouts, dependent: :destroy

  validates :name, presence: true
  validates :email, uniqueness: {case_sensitive: false}, allow_blank: true
  validates :locale, presence: true, inclusion: {in: I18n.available_locales.map(&:to_s)}
  validates :time_zone, presence: true, inclusion: {in: ActiveSupport::TimeZone::MAPPING.keys}
  validates :remember_me_token, presence: true, uniqueness: true

  before_validation :generate_remember_me_token, on: [:create]

  def complete?
    name.present? &&
      email.present? &&
      time_zone.present? &&
      locale.present?
  end

  def just_created?
    persisted? && created_at == updated_at
  end

  # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
  def self.find_or_create_from_auth_hash!(auth_hash)
    find_from_auth_hash(auth_hash) || create_from_auth_hash!(auth_hash)
  end

  def self.find_from_auth_hash(auth_hash)
    Identity.
      where(provider: auth_hash['provider'], uid: auth_hash['uid']).
      first.
      try(:user)
  end

  def self.create_from_auth_hash!(auth_hash)
    transaction do
      user = create!(
        name: auth_hash['info']['name'],
        email: auth_hash['info']['email'],
        locale: I18n.locale,
        time_zone: Time.zone.name
      )
      identity = user.identities.create!(
        provider: auth_hash['provider'],
        uid: auth_hash['uid'],
        info: auth_hash['info'],
        credentials: auth_hash['credentials'],
        extra: auth_hash['extra']
      )
      user.reload
    end
  end

  def latest_workout
    self.workouts.latest.first
  end

  def latest_done_workout
    self.workouts.done.
      order(occurred_on: :desc, scheduled_on: :desc, created_at: :desc).
      limit(1).first
  end

  # TODO spec
  def strava_client
    @strava_client ||= StravaFinderService.new(self).client
  end

  private

  # before_validation on: create
  def generate_remember_me_token
    self.remember_me_token ||= SecureRandom.urlsafe_base64(24)
  end

end
