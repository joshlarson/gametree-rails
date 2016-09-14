class PointsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    in_game_scope(:id => params[:game_id]) do |game|
      game.score += params[:points]
      game.save!
      respond_to do |format|
        format.json { render :json => {}, :status => 201 }
      end
    end
  end
end
