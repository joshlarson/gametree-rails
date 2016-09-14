class Game < ApplicationRecord
  module Status
    FINISHED = "finished"
    IN_PROGRESS = "in progress"
  end

  belongs_to :player
end
