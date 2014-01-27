Kudoz::App.mailer :team do

  email :transfer_email do |transfer, account, hostname |
    from 'Kudoz.io <noreply@kudoz.io>'
    to account.user.email
    subject "#{transfer.ammount} Kudoz for #{transfer.destination.user.name}!"
    locals :transfer => transfer, :account => account, :hostname => hostname
    provides :plain, :html
    render 'team/transfer_email'
  end

end
