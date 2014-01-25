class User < ActiveRecord::Base
  after_create :create_default_account
  has_many :accounts
  
  attr_accessible :name, :provider, :uid, :fname, :lname, :image_url, :email
  
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
      puts "creating user"
      user = User.create(
                  provider: provider,
                  uid: uid,
                  fname: fname,
                  lname: lname,
                  image_url: image_url,
                  email: email)
    end
    
    user
    
  end
  
  protected
    def create_default_account
      unless self.accounts.size > 0
        new_account = Account.create( balance: 100 )
        self.accounts << new_account
      end
    end
  
end
