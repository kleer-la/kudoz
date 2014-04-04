require 'spec_helper'

describe Team do
  
  before(:each) do
    @team = Team.new { |t| t.name = "Equipo de Testing" }
    @acc1 = @team.accounts.build(team: @team, user: User.new)
    @acc2 = @team.accounts.build(team: @team, user: User.new)
  end
  
  it "should list all team transactions" do
    tr = Transfer.new
    tr.origin = @acc1
    tr.destination = @acc2
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    @team.transactions.size.should == 1
  end
  
end