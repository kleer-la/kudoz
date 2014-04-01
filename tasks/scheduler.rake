# Tasks for scheduler
# padrino rake notify_transfers[kudoz.io]

desc "Send transfer notificatios"
task :notify_transfers, [:hostname] => :environment do |t, args|
  hostname = args[:hostname] ||= 'localhost:3000'

  NotificationHelper.notify_transfers(hostname)
end
