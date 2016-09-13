class PlayersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    _respond_with_player Player.where(:email => params[:email]).first
  end

  def show
    _respond_with_player Player.where(:id => params[:id]).first
  end

  def _respond_with_player player
    respond_to do |format|
      if player
        format.json { render :json => player }
      else
        format.json { render :json => {:error => "No players exist with email #{email}"}, :status => 404 }
      end
    end
  end

  def create
    player = Player.new(
      :email => params[:player][:email],
      :handle => params[:player][:handle],
    )

    respond_to do |format|
      if player.valid?
        player.save!
        format.json { render :json => player }
      else
        format.json { render :json => player.errors, :status => 422 }
      end
    end
  end
end
