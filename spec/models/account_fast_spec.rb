require './models/account_logic'

class AccountStub
  include AccountLogic
end

describe "Account" do
  
  let(:account) do
    account = AccountStub.new
    account
  end

  it "should have 100 Kudoz upon creation" do
    account.stub(:balance => 100)
    account.balance.should == 100
  end
  
  it "should have no transactions upon creation" do
    account.stub(:withdrawals => [])
    account.stub(:deposits => [])
    account.transactions.count.should == 0
  end
  
end
