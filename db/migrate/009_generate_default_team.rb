class GenerateDefaultTeam < ActiveRecord::Migration
  def self.up
    # Should't use models oudated collumn information
    Account.reset_column_information
    Team.reset_column_information

    team = Team.create( name: "My Team" )
    Account.all.each do |account|
      account.team = team
      account.save!
    end
  end

  def self.down
    # Should't use models oudated collumn information
    Account.reset_column_information
    Team.reset_column_information

    Account.all.each do |account|
      account.team = nil
      account.save!
    end
    
    Team.all.each do |team|
      team.destroy
    end
    
  end
end
