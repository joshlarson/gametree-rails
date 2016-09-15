class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if Game.where(:status => Game::Status::IN_PROGRESS).exists?
      return respond_to do |format|
        format.json { render :json => {:error => "Cannot create a game while another game is ongoing"}, :status => 403 }
      end
    end

    in_player_scope(:id => params[:player_id]) do |player|
      game = Game.create!(
        :player => player,
        :status => Game::Status::IN_PROGRESS,
        :cost => 0,
        :score => 0,
      )

      respond_to do |format|
        format.json { render :json => game, :status => 201 }
      end
    end
  end

  def show
    in_game_scope(:id => params[:id]) do |game|
      respond_to do |format|
        format.json { render :json => game }
      end
    end
  end
end
