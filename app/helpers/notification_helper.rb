require 'mail'

class NotificationHelper

  def self.notify_transfers(hostname)

    Transfer.find_all_by_notified(false).each do |transfer|
      begin
        notify_transfer(transfer, hostname)
        
        transfer.notified = true
        transfer.save!
        
        puts "Transfer #{transfer} notified."
      rescue Exception => e
        puts e.message
      end
    end

  end

  def self.notify_transfer(transfer, hostname)
    
    transfer.destination.team.accounts.each do |account|
      if !account.user.email.nil? && account.user.email != ""
        Kudoz::App.deliver(:team, :transfer_email, transfer, account, hostname)
      end
    end
    
  end

  def self.notify_invite(invite, hostname)
    Kudoz::App.deliver(:user, :invitation_email, invite, hostname)
  end

  def self.notify_new_joiner(new_account, account, hostname)
    Kudoz::App.deliver(:team, :new_joiner_email, new_account, account, hostname)
  end

  def self.notify_feedback_cycle_start(destination_account)
  	Kudoz::App.deliver(:account, :feedback_cycle_start_email, destination_account)
  end

  def self.notify_feedback_cycle_discount(discount_transfer)
  	Kudoz::App.deliver(:account, :feedback_cycle_discounted_email, discount_transfer)
  end

  def self.notify_feedback_cycle_end(feedback_cycle, user)
  	Kudoz::App.deliver(:account, :feedback_cycle_finish_email, feedback_cycle, user)
  end
end