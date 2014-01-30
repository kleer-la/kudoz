Kudoz::App.mailer :user do

  email :invitation_email do |invite, hostname|
        from 'Kudoz.io <no-reply@kudoz.io>'
        to invite.guest_email
        subject "Invitation to be part of #{invite.team.name}!"
        locals :invite => invite, :hostname => hostname
        provides :plain, :html
        render 'user/invitation_email'
  end

end
