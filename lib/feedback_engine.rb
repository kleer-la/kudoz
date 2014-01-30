module FeedbackEngine

  def self.start_feedback_cycle(execute = false)
    kudozio = User.where( "is_kudozio = ?", true ).first
    kleer = Team.where( "name = ?", "Kleer" ).first
    
    if !kleer.nil? && !kudozio.nil?
      kudozio_account = kudozio.accounts.first
      
      if !kudozio_account.nil?
        kleer.accounts.each do |destination_account|
      
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