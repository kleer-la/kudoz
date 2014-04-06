class User < ActiveRecord::Base

  has_many :accounts, dependent: :destroy
  has_many :teams, through: :accounts
  
  attr_accessible :name, :provider, :uid, :fname, :lname, :image_url, :email, :accounts, :needs_initialization, :twitter, :mood, :is_kudozio
  
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
  
end