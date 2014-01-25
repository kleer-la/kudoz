class User < ActiveRecord::Base

  has_many :accounts, dependent: :destroy
  has_many :teams, through: :accounts
  
  attr_accessible :name, :provider, :uid, :fname, :lname, :image_url, :email, :accounts, :needs_initialization
  
  def name
    "#{self.fname} #{self.lname}"
  end
  
  def self.find_for_omniouth(provider, auth)
    
    uid = auth["uid"]
    fname = auth["info"]["first_name"]
    lname = auth["info"]["last_name"]
    image_url = auth["info"]["image"]
    email = auth["info"]["email"]
    
    user = User.where("provider = ? AND uid = ?", provider, uid).first

    unless user
      
      User.transaction do
      
        user = User.create(
                  provider: provider,
                  uid: uid,
                  fname: fname,
                  lname: lname,
                  image_url: image_url,
                  email: email,
                  accounts: [ Account.create( balance: 100 ) ],
                  needs_initialization: true )
                  
        user.accounts.first.update_attributes!( :team => Team.create( name: "My Team" ) )
      
      end
    
    end
    
    user
    
  end
  
end
