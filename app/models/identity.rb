class Identity < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :provider, presence: true,
    inclusion: {in: %w(strava)}, uniqueness: {scope: [:user_id]}
  validates :uid, presence: true, uniqueness: {scope: [:provider]}

end
