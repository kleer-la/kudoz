# Tasks for scheduler
# padrino rake notify_transfers[kudoz.io]

desc "Send transfer notificatios"
task :notify_transfers, [:hostname] => :environment do |t, args|
  hostname = args[:hostname] ||= 'localhost:3000'
  
  Transfer.find_all_by_notified(false).each do |transfer|
    begin
      NotificationHelper.notify_transfer(transfer, hostname)
      
      transfer.notified = true
      transfer.save!
      
      puts "Transfer #{transfer} notified."
    rescue Exception => e
      puts e.message
    end
  end
  
end
