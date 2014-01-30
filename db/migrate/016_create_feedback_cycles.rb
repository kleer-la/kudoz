class CreateFeedbackCycles < ActiveRecord::Migration
  def self.up
    create_table :feedback_cycles do |t|
      t.integer :team_id
      t.datetime :started_on
      t.datetime :finished_on
      t.timestamps
    end
  end

  def self.down
    drop_table :feedback_cycles
  end
end
