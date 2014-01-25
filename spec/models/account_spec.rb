require 'spec_helper'

describe Account do
  
  it "should have 100 Kudoz upon creation" do
    account = Account.create
    account.balance.should == 100
  end
  
end
