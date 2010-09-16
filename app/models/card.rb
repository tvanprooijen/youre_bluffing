class Card < ActiveRecord::Base
  belongs_to :card_holder, :polymorphic => true
end
