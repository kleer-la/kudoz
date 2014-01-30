class Team < ActiveRecord::Base
  has_many :accounts
  has_many :feedback_cycles
  
  has_many :withdrawals, through: :accounts
  has_many :deposits, through: :accounts
  
  
  validates :name, :presence => true
  
  def transactions
    (withdrawals | deposits).sort! {|a, b| b.created_at <=> a.created_at }
  end
  
end
