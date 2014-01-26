require 'spec_helper'

describe User do
  
  before(:each) do
    @team1 = Team.create( name: "Equipo de Testing 1" )
    @u1 = User.create( accounts: [ Account.create( team: @team1 ) ] )
    @u2 = User.create( accounts: [ Account.create( team: @team1 ) ] )
    
    @team2 = Team.create( name: "Equipo de Testing 2" )
    @u1.accounts << Account.create( team: @team2 )
    @u3 = User.create( accounts: [ Account.create( team: @team2 ) ] )
  end
  
  it "should list all visible transactions" do
    tr = Transfer.new
    tr.origin = @u1.accounts.first
    tr.destination = @u2.accounts.first
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr = Transfer.new
    tr.origin = @u1.accounts.last
    tr.destination = @u3.accounts.first
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    @u1.visible_transactions.size.should == 2
    
  end
    
end
