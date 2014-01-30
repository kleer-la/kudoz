module FeedbackEngine

  def self.start_feedback_cycle(team_name = "Kleer", execute = false)
    
    kudozio = User.where( "is_kudozio = ?", true ).first
    team = Team.where( "name = ?", team_name ).first
    
    if !team.nil? && !kudozio.nil?
      kudozio_account = kudozio.accounts.first
      
      if execute
        feedback_cycle = FeedbackCycle.new
        feedback_cycle.team = team
        feedback_cycle.started_on = Time.now
        feedback_cycle.save!
      end
      
      if !kudozio_account.nil?
        team.accounts.each do |destination_account|
      
          tx = Transfer.new
          tx.ammount = 100
          tx.message = "Here you go some Kudoz for the Feedback Cycle!!"
          tx.origin = kudozio_account
          tx.destination = destination_account
      
          begin
            if execute
              tx.execute!
              Kudoz::App.deliver(:account, :feedback_cycle_start_email, destination_account )
            else
              puts tx.to_s
            end
          rescue Exception => e
            puts e.message
          end
      
        end
      end
    end
    
  end

end