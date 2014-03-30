require 'mail'

class NotificationHelper

  def self.notify_transfer(transfer, hostname)
    
    transfer.destination.team.accounts.each do |account|
      if !account.user.email.nil? && account.user.email != ""
        Kudoz::App.deliver(:team, :transfer_email, transfer, account, hostname)
      end
    end
    
  end

end