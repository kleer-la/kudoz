class Transfer < ActiveRecord::Base
    belongs_to :origin, :class_name => "Account", :foreign_key => "origin_account_id"  
    belongs_to :destination, :class_name => "Account", :foreign_key => "destination_account_id"
    
    validates :message, :ammount, :origin, :destination, :presence => true
    
    def execute!
        
        if !destination.user.is_kudozio
        
          if !origin.user.is_kudozio
            if origin.team.id != destination.team.id
              raise 'Transfers are allowed only between accounts of the same team.'
            elsif self.ammount > self.origin.balance
              raise "There're not enough Kudoz for this deposit."
            elsif self.ammount < 0
              raise "Can't deposit negative amounts."
            end
          end
        
          self.save!
        
          Transfer.transaction do
        
            if !origin.user.is_kudozio
              origin.update_attributes!( :balance => origin.balance - ammount )
            end
          
            destination.update_attributes!( :balance => destination.balance + ammount )
            self.save!
        
          end
        
        else
          raise "You can't transfer Kudos to Kudozio The Great."
        end
      
    end
    
    def to_s
      "#{self.ammount} Kudos from #{self.origin.user.name} to #{self.destination.user.name}: #{self.message}"
    end
    
end
