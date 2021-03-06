class GamesController < ApplicationController
  
  before_filter :setup, :except => [:create, :index]
  
  private 
  def setup
    @game = Game.find(params[:id], :include => [:players, :current_player, :deck])
  end
  
  public
  
  def index
    @games = Game.all
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game.to_xml(:include => [:players, :current_player, :deck]) }
    end
  end


  def create
    @game = Game.create(params[:game])
    @player = @game.players.create :name => player_name
    redirect_to(@game)
  end


  def update
    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def start
    xml_event :start
  end
  
  def fail
    xml_event :fail
  end
  
  def next_player
    @game.next_player
    respond_to do |format|
      format.xml {head :ok} 
    end
  end
  
  private
  def xml_event(event)
    respond_to do |format|
      format.xml do
        @game.send event
        head :ok
      end
    end
  end
  
end
