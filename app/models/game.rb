class Game < ActiveRecord::Base
  include AASM
  
  has_many  :players,
            :order => "created_at",
            :after_add  => Proc.new { |game, player| 
              game.ready if game.players.count == 4
            }
            
  belongs_to  :current_player, :class_name => 'Player'
  belongs_to  :next_player_in_bidding_round, :class_name => 'Player'
  belongs_to  :trade_partner, :class_name => 'Player'
  
  
  has_many :deck, :as => :card_holder, :class_name => 'Card'
  
  aasm_column :status
  aasm_initial_state :open_for_players
    
  aasm_state :open_for_players
  aasm_state :starting, 
    :after_enter => Proc.new {|game|
      game.save! # make sure the status: 'starting' is saved before we initiate the processing backend
      game.build_deck!
      begin
        p = GameProcess.create :game_id => game.id 
        game.pid = p.id
      rescue Object
        game.fail
      ensure
        game.save! # save pid or the status: 'failed'
      end
    }
  aasm_state :playing, :after_enter => Proc.new {|game| game.save!}
  aasm_state :failed, :after_enter => Proc.new {|game| game.save!}
  aasm_state :cancelled
  aasm_state :finished
  
  aasm_event (:start) { transitions :to => :playing, :from => [:starting] }
  aasm_event (:ready) { transitions :to => :starting, :from => [:open_for_players] }
  aasm_event (:fail)  { transitions :to => :failed, :from => [:open_for_players, :starting, :playing] }
  aasm_event (:cancel) { transitions :to => :cancelled, :from => [:open_for_players, :playing] }
  aasm_event (:winner) { transitions :to => :finished, :from => [:playing] }
  
  
  def next_player
    self.current_player = if current_player && players.size > 1
      players.reject{|p|p.id == current_player.id}.first
    else
      players.first
    end
    save!
  end
  
  def build_deck!
    [ ['Rooster', 10    ],
      ['Goose',   40    ],
      ['Cat',     90    ],
      ['Dog',     160   ],
      ['Sheep',   250   ],  
      ['Goat',    350   ],
      ['Donkey',  500   ],
      ['Pig',     650   ],
      ['Cow',     800   ],
      ['Horse',   1000  ]].each{|set| 
        4.times{ 
          deck.create({
            :card_type  => set[0],
            :value      => set[1] }) }}
  end
  
end
