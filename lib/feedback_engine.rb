module FeedbackEngine

  def self.start_feedback_cycle(team_id = 0, execute = false)
    
    team = Team.find( team_id )
    
    if !team.nil?
      fc = FeedbackCycle.create( team: team )
      if execute
        fc.start!.each do |destination_account|
          Kudoz::App.deliver(:account, :feedback_cycle_start_email, destination_account )
        end
      else
        fc.start
      end
    end
    
  end
  
  def self.finish_feedback_cycle(id = 0, execute = false)
    
    fc = FeedbackCycle.find(id)
    
    if execute
      fc.finish!.each do |discount_transfer|
        puts discount_transfer.to_s
        Kudoz::App.deliver(:account, :feedback_cycle_discounted_email, discount_transfer )
      end
      
      fc.team.users.each do |user|
        Kudoz::App.deliver(:account, :feedback_cycle_finish_email, fc, user )
      end
      
    else
      fc.finish
    end
    
  end

end