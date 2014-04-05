class Transfer < ActiveRecord::Base
  belongs_to :origin, :class_name => "Account", :foreign_key => "origin_account_id"  
  belongs_to :destination, :class_name => "Account", :foreign_key => "destination_account_id"
  
  validates :message, :ammount, :origin, :destination, :presence => true
  
  def self.build(origin_account, destination_account, ammount, message)
    transfer = Transfer.new { |tx| 
      tx.ammount = ammount
      tx.message = message
      tx.origin = origin_account
      tx.destination = destination_account
    }
    origin_account.withdrawals << transfer
    destination_account.deposits << transfer
    return transfer
  end

  def execute!
    
    if destination.user.is_kudozio
      raise "You can't transfer Kudos to Kudozio The Great."
    end
    
    unless origin.user.is_kudozio
      if origin.team.id != destination.team.id
        raise 'Transfers are allowed only between accounts of the same team.'
      elsif self.ammount > self.origin.balance
        raise "There're not enough Kudoz for this deposit."
      elsif self.ammount < 0
        raise "Can't deposit negative amounts."
      end
    end
  
    # self.save!

    # Transfer.transaction do
  
      unless origin.user.is_kudozio
        origin.update_attributes!( :balance => origin.balance - ammount )
      end
    
      destination.update_attributes!( :balance => destination.balance + ammount )
  
    # end

    self.save!
  
  end
  
  def to_s
    "#{self.ammount} Kudos from #{self.origin.user.name} to #{self.destination.user.name}: #{self.message}"
  end
  
end