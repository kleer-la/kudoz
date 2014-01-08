class Account < ActiveRecord::Base
  
  def self.find_for_omniouth(provider, uid, name)
    
    account = Account.where("provider = ? AND uid = ?", provider, uid).first

    unless account
      puts "creating account"
      account = Account.create(
                  provider: provider,
                  uid: uid,
                  name: name,
                  balance: 100)
    end
    
    account
    
  end
  
end
