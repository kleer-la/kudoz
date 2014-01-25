class Transfer < ActiveRecord::Base
    belongs_to :origin, :class_name => "Account", :foreign_key => "origin_account_id"  
    belongs_to :destination, :class_name => "Account", :foreign_key => "destination_account_id"
    
    def execute!
      
      if origin.team.id != destination.team.id
        raise 'Transfers are allowed only between accounts of the same team.'
      else
        
        Transfer.transaction do
        
          origin.update_attributes!( :balance => origin.balance - ammount )
          destination.update_attributes!( :balance => destination.balance + ammount )
        
        end
        
      end
      
    end
    
end
