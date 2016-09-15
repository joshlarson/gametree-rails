class ChargesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    in_active_game_scope(:id => params[:game_id]) do |game|
      game.cost += params[:amount]
      game.save!

      BraintreeService.new.charge_customer(game.player.handle, params[:amount])

      respond_to do |format|
        format.json { render :json => {}, :status => 201 }
      end
    end
  end
end
