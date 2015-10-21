class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy

  validates :name, presence: true
  validates :email, uniqueness: {case_sensitive: false}, allow_blank: true
  validates :locale, presence: true, inclusion: {in: I18n.available_locales.map(&:to_s)}
  validates :time_zone, presence: true, inclusion: {in: ActiveSupport::TimeZone::MAPPING.keys}

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

end
