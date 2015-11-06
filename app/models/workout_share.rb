class WorkoutShare
  include ActiveModel::Model

  attr_accessor :workout, :emails

  validates :workout, presence: true
  validates :emails, presence: true, format: {
    with: /\A((\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)\s*[,]{0,1}\s*)+\z/i
  } # multiple valid emails separated by commas (but allows last empty comma :\)

end
