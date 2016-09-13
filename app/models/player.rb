class Player < ApplicationRecord
  validates :email, :uniqueness => true
  validates :handle, :uniqueness => true
end
