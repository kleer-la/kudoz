class Team < ActiveRecord::Base
  has_many :accounts
  
  has_many :withdrawals, through: :accounts
  has_many :deposits, through: :accounts
  
  def transactions
    (withdrawals | deposits).sort! {|a, b| b.created_at <=> a.created_at }
  end
  
end
