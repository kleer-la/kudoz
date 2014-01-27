class User < ActiveRecord::Base

  has_many :accounts, dependent: :destroy
  has_many :teams, through: :accounts
  
  attr_accessible :name, :provider, :uid, :fname, :lname, :image_url, :email, :accounts, :needs_initialization
  
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
  
  def self.find_for_omniouth(provider, auth, invite_uuid)
    
    uid = auth["uid"]
    fname = auth["info"]["first_name"]
    lname = auth["info"]["last_name"]
    image_url = auth["info"]["image"]
    email = auth["info"]["email"]
    
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
                  accounts: [ Account.create( balance: 100 ) ],
                  needs_initialization: true )
        
        if invite_uuid.nil?
          user.accounts.first.update_attributes!( :team => Team.create( name: "My Team" ) )
        end

      end
    
    end

    if !invite_uuid.nil?
      invite = Invite.where("uuid = ?", invite_uuid).first
      if !invite.nil?
        user.accounts << Account.create( balance: 100, team: invite.team )
        user.needs_initialization = false
        user.save!
        
        invite.update_attributes!( :acepted => true )
      end
    end
    
    user
    
  end
  
end
