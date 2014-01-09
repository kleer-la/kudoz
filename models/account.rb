class Account < ActiveRecord::Base
  
  
  
  has_many :withdrawals, :class_name => "Transfer", :foreign_key => "origin_account_id" 
  has_many :deposits, :class_name => "Transfer", :foreign_key => "destination_account_id"
  
  def self.find_for_omniouth(provider, auth)
    
    uid = auth["uid"]
    name = auth["info"]["name"]
    image_url = auth["info"]["image"]
    email = auth["info"]["email"]
    
    account = Account.where("provider = ? AND uid = ?", provider, uid).first

    unless account
      puts "creating account"
      account = Account.create(
                  provider: provider,
                  uid: uid,
                  name: name,
                  image_url: image_url,
                  email: email,
                  balance: 100)
    end
    
    account
    
  end
  
  def transactions
    puts "self.withdrawals: #{self.withdrawals.count}"
    puts "self.deposits: #{self.deposits.count}"
    
    (withdrawals | deposits).sort! {|a, b| b.created_at <=> a.created_at }
  end
  
end
