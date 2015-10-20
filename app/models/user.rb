class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy

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
      user = create!(name: auth_hash['info']['name'], email: auth_hash['info']['email'])
      identity = user.identities.create!(provider: auth_hash['provider'], uid: auth_hash['uid'], info: auth_hash['info'], credentials: auth_hash['credentials'], extra: auth_hash['extra'])
      user.reload
    end
  end

end
