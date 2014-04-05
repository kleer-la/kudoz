class FeedbackCycle < ActiveRecord::Base

  belongs_to :team
  has_many :positions, :class_name => "FeedbackCyclePosition"
  
  def start!(kudozio_account)
    start(kudozio_account, true)
  end
  
  def start(kudozio_account, execute=false)
    
    if self.team.nil? || kudozio_account.nil?
      return []
    end

    if execute
      self.started_on = Time.now
      self.save!
    end
    
    self.team.accounts.each do |destination_account|

      tx = Transfer.build(
        kudozio_account, destination_account,
        100, "Here you go some Kudoz for the Feedback Cycle!!"
      )
  
      begin
        if execute
          tx.execute!
        else
          puts tx.to_s
        end
      rescue Exception => e
        puts e
        puts "ERROR: #{e.message}"
      end
  
    end
    
    if execute
      self.team.accounts
    else
      []
    end
    
  end
  
  def finish!(kudozio_account)
    finish(kudozio_account, true)
  end
  
  def finish(kudozio_account, execute=false)
    
    discounts = Array.new
    givvers = Hash.new
    getters = Hash.new
    
    start_time = self.started_on
    
    if self.team.nil? || kudozio_account.nil?
      return discounts
    end

    feedback_cycle_transactions = self.team.transactions.select { |t| 
      t.created_at >= start_time && !t.origin.user.is_kudozio
    }

    feedback_cycle_transactions.each do |tx|
    
      # solo cuentan los primeros 100 kudoz
      this_tx_trimmed_ammount = tx.ammount <= 100 ? tx.ammount : 100
    
      # solo si el dador no se pasó ya de 100 kudoz entregados
      if givvers[tx.origin.user.id].nil? || givvers[tx.origin.user.id] < 100
    
        # si no hay registros de este "dador"
        if givvers[tx.origin.user.id].nil?
          # lo inicializa
          givvers[tx.origin.user.id] = this_tx_trimmed_ammount
        else
          # si hay registro y con esta transfer se pasa de 100
          if givvers[tx.origin.user.id] + this_tx_trimmed_ammount > 100
            # la transfer se reduce para no pasarse de 100
            this_tx_trimmed_ammount = 100 - this_tx_trimmed_ammount
            # llega a 100
            givvers[tx.origin.user.id] = 100
          else
            # se incrementa sus envios
            givvers[tx.origin.user.id] = givvers[tx.origin.user.id] + this_tx_trimmed_ammount
          end
        end
    
        if getters[tx.destination.user.id].nil?
          getters[tx.destination.user.id] = this_tx_trimmed_ammount
        else
          getters[tx.destination.user.id] = getters[tx.destination.user.id] + this_tx_trimmed_ammount
        end
      
      end
    
    end
  
    self.team.users.each do |usr|
      
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
        
        source_account = self.team.accounts.select{ |account| account.user.id == usr.id }.first.reload

        tx = Transfer.build(
          kudozio_account, source_account,
          remove*-1, "Give these Kudoz back to me! Next time remember to give away 100 kudoz. :P"
        )
        
        if execute
          discounts << tx
          tx.execute!
        else        
          puts tx.to_s
        end
        
      end
      
    end
  
    if execute 
      getters.each do |key, val|
        self.positions << FeedbackCyclePosition.create( user: User.find(key), received_kudoz: val )
      end
      
      self.finished_on = Time.now
      self.save!
    end
    
    discounts
  
  end

end