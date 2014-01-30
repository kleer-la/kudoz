Kudoz::App.mailer :account do

  email :feedback_cycle_start_email do |account|
        from 'Kudozio The Great <no-reply@kudoz.io>'
        to account.user.email
        subject "Feedback Cycle Start at #{account.team.name}!"
        locals :account => account
        provides :plain, :html
        render 'account/feedback_cycle_start_email'
  end

end