class PlayersController < ApplicationController

  def create
    @game = Game.find params[:game_id]
    @player = @game.players.create :name => player_name
    redirect_to(@game)
  end

end
