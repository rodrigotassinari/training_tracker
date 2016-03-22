class Identity < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :provider, presence: true,
    inclusion: {in: %w(strava)}, uniqueness: {scope: [:user_id], case_sensitive: false}
  validates :uid, presence: true, uniqueness: {scope: [:provider], case_sensitive: false}

end
