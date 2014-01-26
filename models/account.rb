class Account < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :team
  
  has_many :withdrawals, :class_name => "Transfer", :foreign_key => "origin_account_id" 
  has_many :deposits, :class_name => "Transfer", :foreign_key => "destination_account_id"
  
  before_create :set_default_values
  
  def transactions
    (withdrawals | deposits).sort! {|a, b| b.created_at <=> a.created_at }
  end
  
  protected
    def set_default_values
      self.balance = 100
    end
  
end
