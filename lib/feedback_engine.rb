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
  
  def self.finish_feedback_cycle(id = 0, execute = false)
    
    feedback_cycle = FeedbackCycle.find(id)
    
    if !feedback_cycle.nil?
      
      givvers = Hash.new
      getters = Hash.new
      
      team = feedback_cycle.team
      start_time = feedback_cycle.started_on
      
      team.transactions.select { |t| t.created_at >= start_time && !t.origin.user.is_kudozio }.each do |tx|
        
        if givvers[tx.origin.user.id].nil?
          givvers[tx.origin.user.id] = tx.ammount
        else
          givvers[tx.origin.user.id] = givvers[tx.origin.user.id] + tx.ammount
        end
        
        if getters[tx.destination.user.id].nil?
          if tx.ammount <= 100
            getters[tx.destination.user.id] = tx.ammount
          else
            getters[tx.destination.user.id] = 100
          end
        else
          if getters[tx.destination.user.id] < 100
            if (getters[tx.destination.user.id] + tx.ammount) <= 100
              getters[tx.destination.user.id] = getters[tx.destination.user.id] + tx.ammount
            else
              getters[tx.destination.user.id] = 100
            end
          end
        end
        
      end
      
      team.users.each do |usr|
        if givvers[usr.id].nil?
          givvers[usr.id] = 0
        elsif givvers[usr.id] > 100
          givvers[usr.id] = 100
        end
        
        if getters[usr.id].nil?
          getters[usr.id] = 0
        end
          
        
        remove = (100-givvers[usr.id])*2
        
        if remove > 0
          puts "Remove #{remove} from #{usr.name} at #{team.name}"
        end
      end
      
      puts "Ranking"
      getters.each do |key, val|
        puts "#{key}: #{val}"
      end
      
      if execute
        feedback_cycle.finished_on = Time.now
        feedback_cycle.save!
      end
      
    end
    
  end

end