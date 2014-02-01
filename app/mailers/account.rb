Kudoz::App.mailer :account do

  email :feedback_cycle_start_email do |account|
        from 'Kudozio The Great <no-reply@kudoz.io>'
        to account.user.email
        subject "Feedback Cycle Start at #{account.team.name}!"
        locals :account => account
        provides :plain, :html
        render 'account/feedback_cycle_start_email'
  end
  
  email :feedback_cycle_discounted_email do |transfer|
    from 'Kudozio The Great <no-reply@kudoz.io>'
    to transfer.destination.user.email
    subject "Give me these Kudoz Back!"
    locals :transfer => transfer
    provides :plain, :html
    render 'account/feedback_cycle_discounted_email'
  end

  email :feedback_cycle_finish_email do |feedback_cycle, user|
    from 'Kudozio The Great <no-reply@kudoz.io>'
    to user.email
    subject "Feedback Cycle Finished at #{feedback_cycle.team.name}!"
    locals :feedback_cycle => feedback_cycle, :user => user
    provides :plain, :html
    render 'account/feedback_cycle_finish_email'
  end

end