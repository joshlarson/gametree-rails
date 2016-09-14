class Game < ApplicationRecord
  module Status
    IN_PROGRESS = "in progress"
  end

  belongs_to :player
end
