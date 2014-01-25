class GenerateUsersFromAccounts < ActiveRecord::Migration
  
  def self.up
    Account.all.each do |account|
      user = User.create( fname: account.name.split(" ")[0],
                          lname: account.name.split(" ")[1],
                          email: account.email,
                          image_url: account.image_url,
                          uid: account.uid,
                          provider: account.provider)
      account.user = user
      account.save!
    end
  end

  def self.down
    User.all.each do |user|
      user.account.name = user.fname + " " + user.lname
      user.account.email = user.email
      user.account.image_url = user.image_url
      user.account.uid = user.uid
      user.account.provider = user.provider
      user.account.save!
    end
  end
  
end
