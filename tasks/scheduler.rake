# Tasks for scheduler
# padrino rake notify_transfers[kudoz.io]

desc "Send transfer notifications"
task :notify_transfers, [:hostname] => :environment do |t, args|
  hostname = args[:hostname] ||= 'localhost:3000'

  NotificationHelper.notify_transfers(hostname)
end

desc "Start feedback cycles if needed"
task :start_feedback_cycle, [:hostname] => :environment do |t, args|
  hostname = args[:hostname] ||= 'localhost:3000'

  # Solo para los ciclos de feedback de Kleer, por ahora (kleer_team_id: 1)
  if (Date.today.day==1 or Date.today.day==16)
    FeedbackEngine.start_feedback_cycle(1, true)
  end

end

desc "End feedback cycles if time is up"
task :end_feedback_cycle, [:hostname] => :environment do |t, args|
  hostname = args[:hostname] ||= 'localhost:3000'

  # Solo para los ciclos de feedback de Kleer, por ahora (kleer_team_id: 1)
  FeedbackCycle.where(team_id: 1, finished_on: nil).each { |fc|
    if (Date.today-fc.started_on.to_date).to_i >= 5
      FeedbackEngine.finish_feedback_cycle(fc.id, true)
    end
  }

end
