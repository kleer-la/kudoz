require 'spec_helper'

describe Team do
  
  before(:each) do
    @team = Team.create( name: "Equipo de Testing" )
    @u1 = User.create( accounts: [ Account.create( team: @team ) ] )
    @u2 = User.create( accounts: [ Account.create( team: @team ) ] )
  end
  
  it "should list all team transactions" do
    tr = Transfer.new
    tr.origin = @u1.accounts.first
    tr.destination = @u2.accounts.first
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    @team.transactions.size.should == 1
  end
  
end
