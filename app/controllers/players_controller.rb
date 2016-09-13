class PlayersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    email = params[:email]
    player = Player.where(:email => email).first

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
