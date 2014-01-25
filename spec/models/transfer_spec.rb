require 'spec_helper'

describe Transfer do
  before(:each) do
    team = Team.create( name: "Equipo de Testing" )
    @u1 = User.create( accounts: [ Account.create( team: team ) ] )
    @u2 = User.create( accounts: [ Account.create( team: team ) ] )
  end
  
  it "should validate the execution is done inside a single team" do
    tr = Transfer.new
    tr.origin = @u1.accounts.first
    tr.destination = @u2.accounts.first
    tr.destination.team = Team.create( name: "Un Equipo Diferente" )
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    expect { tr.execute! }.to raise_error
    
    tr.origin.balance.should == 100
    tr.destination.balance.should == 100
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
