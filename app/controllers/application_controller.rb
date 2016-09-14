class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :in_player_scope

  def in_player_scope(options)
    player = Player.where(options).first
    if player
      yield player
    else
      respond_to do |format|
        format.json { render :json => {:error => "Player not found"}, :status => 404 }
      end
    end
  end
end
