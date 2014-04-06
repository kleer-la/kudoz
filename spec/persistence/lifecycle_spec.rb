require 'support/active_record'

describe "Persistence lifecycle" do
  
  it "new objects should be initialized" do
  	account = Account.new
    account.balance.should == 100
  end
  
  it "loaded objects should not initialized" do
  	account = Account.new
  	account.balance = 50
  	account.save!
  	id = account.id

  	loaded_account = Account.find(id)
    loaded_account.balance.should == 50
  end
  
  # it "should not load two diferent instances" do
  # 	account = Account.new
  # 	account.balance = 50
  # 	account.save!
  # 	id = account.id

  # 	loaded_account_1 = Account.find(id)
  # 	loaded_account_1.balance = 33

  # 	loaded_account_2 = Account.find(id)

  #   loaded_account_1.balance.should == 33
  #   loaded_account_2.balance.should == 33
  # end
  
end
