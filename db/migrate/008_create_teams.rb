class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name
      t.timestamps
    end
    
    change_table :accounts do |t|
      t.integer :team_id
    end
    
  end

  def self.down
    drop_table :teams
    
    change_table :accounts do |t|
      t.remove :team_id
    end
    
  end
end
