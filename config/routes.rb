ActionController::Routing::Routes.draw do |map|
  

  map.resources :games

  
  map.resources :games,
    :member => { :start => :put,
      :fail => :put,
      :next_player => :put } do |game|
        game.resources :players, :only => [:create]
  end
  
  map.root :controller => "games"
end
