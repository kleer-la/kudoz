class CreateFeedbackCyclePositions < ActiveRecord::Migration
  def self.up
    create_table :feedback_cycle_positions do |t|
      t.integer :user_id
      t.integer :feedback_cycle_id
      t.integer :received_kudoz
      t.timestamps
    end
  end

  def self.down
    drop_table :feedback_cycle_positions
  end
end
