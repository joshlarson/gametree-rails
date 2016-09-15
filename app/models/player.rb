class Player < ApplicationRecord
  validates :email, :uniqueness => true
  validates :handle, :uniqueness => true

  has_many :games

  def high_score
    games.maximum(:score)
  end
end
