Kudoz::App.mailer :team do

  email :transfer_email do |transfer, account, hostname |
    from 'Kudoz.io <no-reply@kudoz.io>'
    to account.user.email
    subject "#{transfer.ammount} Kudoz for #{transfer.destination.user.name}!"
    locals :transfer => transfer, :account => account, :hostname => hostname
    provides :plain, :html
    render 'team/transfer_email'
  end

  email :new_joiner_email do |new_joiner_account, account, hostname|
    from 'Kudoz.io <no-reply@kudoz.io>'
    to account.user.email
    subject "Welcome #{new_joiner_account.user.fname} to #{account.team.name} team!"
    locals :new_joiner_account => new_joiner_account, :account => account, :hostname => hostname
    provides :plain, :html
    render 'team/new_joiner_email'
  end

end
