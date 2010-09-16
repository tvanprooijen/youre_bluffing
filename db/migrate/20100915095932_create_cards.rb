class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.string :card_holder_type
      t.integer :card_holder_id
      t.string :card_type
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
