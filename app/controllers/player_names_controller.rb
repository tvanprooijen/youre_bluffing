class PlayerNamesController < ApplicationController
  
  skip_before_filter :require_player_name

  def edit
    
  end
  
  def update
    session[:player_name] = params[:name]
    redirect_to root_path
    
  end

end