# Tasks for scheduler
# padrino rake notify_transfers

desc "Send transfer notificatios"
task :notify_transfers => :environment do
  
  Transfer.find_all_by_notified(false).each do |transfer|
    begin
      NotificationHelper.notify_transfer(transfer, nil)
      
      transfer.notified = true
      transfer.save!
      
      puts "Transfer #{transfer} notified."
    rescue Exception => e
      puts e.message
    end
  end
  
end