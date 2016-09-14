class PlayersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    in_player_scope(:email => params[:email]) do |player|
      respond_to do |format|
        format.json { render :json => player }
      end
    end
  end

  def show
    in_player_scope(:id => params[:id]) do |player|
      respond_to do |format|
        format.json { render :json => player }
      end
    end
  end

  def create
    email = params[:player][:email]
    handle = params[:player][:handle]

    player = Player.new(
      :email => email,
      :handle => handle,
    )

    respond_to do |format|
      if player.valid?
        player.save!
        BraintreeService.new.create_customer(handle, email)
        format.json { render :json => player, :status => 201 }
      else
        format.json { render :json => player.errors, :status => 422 }
      end
    end
  end
end
