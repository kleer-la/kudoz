class AddMoodToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :mood
    end
    
    User.all.each do |user|
      user.mood = "happy"
      user.save!
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :mood
    end
  end
end
