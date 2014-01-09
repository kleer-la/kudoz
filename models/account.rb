class Account < ActiveRecord::Base
  
  def self.find_for_omniouth(provider, uid, name, image_url)
    
    account = Account.where("provider = ? AND uid = ?", provider, uid).first

    unless account
      puts "creating account"
      account = Account.create(
                  provider: provider,
                  uid: uid,
                  name: name,
                  image_url: image_url,
                  balance: 100)
    end
    
    account
    
  end
  
end
