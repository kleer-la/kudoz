module FeedbackEngine

  def self.start_feedback_cycle(team_id = 0, execute = false)
    
    team = Team.find(team_id)
    
    if !team.nil?

      fc = FeedbackCycle.new(team: team)

      if execute
        fc.start!(get_kudozio_account()).each do |destination_account|
          NotificationHelper.notify_feedback_cycle_start(destination_account)
        end
      else
        fc.start(get_kudozio_account())
      end

      fc.save!
      
    end
    
  end
  
  def self.finish_feedback_cycle(id = 0, execute = false)
    
    fc = FeedbackCycle.find(id)
    
    if execute
      fc.finish!(get_kudozio_account()).each do |discount_transfer|
        puts discount_transfer.to_s
        NotificationHelper.notify_feedback_cycle_discount(discount_transfer)
      end
      
      fc.team.users.each do |user|
        NotificationHelper.notify_feedback_cycle_end(fc, user)
      end
    else
      fc.finish(get_kudozio_account())
    end

    ActiveRecord::Base.transaction do
      fc.save!
      fc.accounts.each { |acc|
        acc.save!
      }
    end
    
  end

  private

  def self.get_kudozio_account()
    User.where("is_kudozio = ?", true).first.accounts.first
  end

end