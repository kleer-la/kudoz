module OmniAuthService

  def self.find_for_omniauth(provider, auth, invite=nil)

    uid = auth.uid
    if provider == "google_oauth2" || provider == "facebook"
      fname = auth.info.first_name
      lname = auth.info.last_name
      image_url = auth.info.image
      email = auth.info.email
      twitter = ""
    elsif provider == "twitter"
      name = auth.info.name
      fname = name.split(' ')[0]
      lname = name.split(' ')[1] == nil ? "" : name.split(' ')[1]
      image_url = auth.info.image
      email = ""
      twitter = auth.info.nickname
    end

    puts "provider: #{provider}"
    puts "uid: #{uid}"
    user = User.where("provider = ? AND uid = ?", provider, uid).first

    if user.nil?

      User.transaction do

        user = User.create(
                  provider: provider,
                  uid: uid,
                  fname: fname,
                  lname: lname,
                  image_url: image_url,
                  email: email,
                  twitter: twitter,
                  mood: "happy")

        if user.email == ""
          user.update_attributes!( :needs_initialization => true )
        end

      end

    end

    if !invite.nil?
      user.accounts << Account.create( balance: 100, team: invite.team )
      user.needs_initialization = ( user.email == "" )
      user.save!

      invite.update_attributes!( :acepted => true )
    elsif user.accounts.size == 0
      user.accounts << Account.create( balance: 100, :team => Team.create( name: "My Initial Team" ) )
      user.needs_initialization = true
      user.save!
    end

    user

  end

end
