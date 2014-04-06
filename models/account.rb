class Account < ActiveRecord::Base

  belongs_to :user
  belongs_to :team
  
  has_many :withdrawals, :class_name => "Transfer", :foreign_key => "origin_account_id" 
  has_many :deposits, :class_name => "Transfer", :foreign_key => "destination_account_id"
  
  after_initialize :set_default_values, if: :new_record?
  
  def transactions
    (withdrawals | deposits).sort! {|a, b| b.created_at <=> a.created_at }
  end

  def deposit(ammount)
    update_attributes!(:balance => self.balance + ammount)
    # self.balance = self.balance + ammount
  end

  def withdraw(ammount)
    update_attributes!(:balance => self.balance - ammount)
    # self.balance = self.balance - ammount
  end

  protected

  def set_default_values
    self.balance = 100
  end

end