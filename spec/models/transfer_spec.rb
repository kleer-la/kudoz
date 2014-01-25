require 'spec_helper'

describe Transfer do
  before(:each) do
    @u1 = User.create
    @u2 = User.create    
  end
  
  it "should transfer 15 koinz from a1 to a2" do
    tr = Transfer.new
    tr.origin = @u1.accounts.first
    tr.destination = @u2.accounts.first
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 85
    tr.destination.balance.should == 115
  end
  
  it "should transfer 40 koinz from a2 to a1" do
    tr = Transfer.new
    tr.origin = @u2.accounts.first
    tr.destination = @u1.accounts.first
    tr.ammount = 40
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 60
    tr.destination.balance.should == 140
  end
  
end
