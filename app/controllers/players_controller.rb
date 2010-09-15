class PlayersController < ApplicationController

  def create
    @game = Game.find params[:game_id]
    @player = @game.players.create :name => current_user_name
    redirect_to(@game)
  end

end
