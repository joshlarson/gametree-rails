class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    player = Player.where(:id => params[:player_id]).first

    game = Game.create!(
      :player => player,
      :status => "in progress",
      :cost => 0,
    )

    respond_to do |format|
      format.json { render :json => game }
    end
  end
end
