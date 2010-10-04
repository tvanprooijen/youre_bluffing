class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  before_filter :require_player_name
  
  helper_method :player_name
  
  
  
  def player_name
    session[:player_name]
  end
  
    
  private 
  def require_player_name
    redirect_to edit_player_name_path if player_name.blank?
  end
  
  
  
  
end
