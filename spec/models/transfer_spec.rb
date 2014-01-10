require 'spec_helper'

describe Transfer do
  before(:each) do
    @a1 = Account.new
    @a2 = Account.new
    
    @a1.name = "Account #1"
    @a1.balance = 100
    
    @a2.name = "Account #2"
    @a2.balance = 200
  end
  
  it "should transfer 15 koinz from a1 to a2" do
    tr = Transfer.new
    tr.origin = @a1
    tr.destination = @a2
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 85
    tr.destination.balance.should == 215
  end
  
  it "should transfer 40 koinz from a2 to a1" do
    tr = Transfer.new
    tr.origin = @a2
    tr.destination = @a1
    tr.ammount = 40
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 160
    tr.destination.balance.should == 140
  end
  
end
