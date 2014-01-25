class GenerateDefaultTeam < ActiveRecord::Migration
  def self.up
    team = Team.create( name: "My Team" )
    Account.all.each do |account|
      account.team = team
      account.save!
    end
  end

  def self.down
    Account.all.each do |account|
      account.team = nil
      account.save!
    end
    
    Team.all.each do |team|
      team.destroy
    end
    
  end
end
