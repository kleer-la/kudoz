require 'support/active_record'

describe Account do
  
  let(:account) do
    Account.new
  end

  it "should have 100 Kudoz upon creation" do
    account.balance.should == 100
  end
  
  it "should have no transactions upon creation" do
    account.transactions.count.should == 0
  end
  
end