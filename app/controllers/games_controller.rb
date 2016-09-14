class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    in_player_scope(:id => params[:player_id]) do |player|
      game = Game.create!(
        :player => player,
        :status => "in progress",
        :cost => 0,
      )

      respond_to do |format|
        format.json { render :json => game, :status => 201 }
      end
    end
  end
end
