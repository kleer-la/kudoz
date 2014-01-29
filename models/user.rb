class User < ActiveRecord::Base

  has_many :accounts, dependent: :destroy
  has_many :teams, through: :accounts
  
  attr_accessible :name, :provider, :uid, :fname, :lname, :image_url, :email, :accounts, :needs_initialization, :twitter, :mood
  
  def name
    "#{self.fname} #{self.lname}"
  end
  
  def visible_transactions
    visible_transactions = Array.new
    self.accounts.each do |account|
      visible_transactions |= account.transactions
    end
    visible_transactions.sort! {|a, b| b.created_at <=> a.created_at }
  end
  
  def self.find_for_omniouth(provider, auth, invite=nil)
    
    uid = auth["uid"]
    if provider == "google_oauth2" || provider == "facebook" 
      fname = auth["info"]["first_name"]
      lname = auth["info"]["last_name"]
      image_url = auth["info"]["image"]
      email = auth["info"]["email"]
      twitter = ""
    elsif provider == "twitter"
      name = auth["info"]["name"]
      fname = name.split(' ')[0]
      lname = name.split(' ')[1] == nil ? "" : name.split(' ')[1]
      image_url = auth["info"]["image"]
      email = ""
      twitter = auth["info"]["nickname"]
    end
    
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
