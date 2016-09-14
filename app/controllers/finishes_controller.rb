class FinishesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    in_active_game_scope(:id => params[:game_id]) do |game|
      game.status = Game::Status::FINISHED
      game.save!
    end
  end
end
