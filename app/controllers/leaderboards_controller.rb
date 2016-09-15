class LeaderboardsController < ApplicationController
  def show
    @players = Player.all.sort_by(&:high_score).reverse.take(25)
  end
end
