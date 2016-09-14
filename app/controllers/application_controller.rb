class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :in_player_scope

  def in_game_scope(options)
    _in_scope(Game, options) do |entity|
      yield entity
    end
  end

  def in_player_scope(options)
    _in_scope(Player, options) do |entity|
      yield entity
    end
  end

  def _in_scope(type, options)
    entity = type.where(options).first
    if entity
      yield entity
    else
      respond_to do |format|
        format.json { render :json => {:error => "#{type} not found"}, :status => 404 }
      end
    end
  end
end
