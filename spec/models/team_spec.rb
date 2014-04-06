require 'support/active_record'

describe Team do
  
  before(:each) do
    @team = Team.new { |t| t.name = "Equipo de Testing" }
    @acc1 = @team.accounts.build(team: @team, user: User.new)
    @acc2 = @team.accounts.build(team: @team, user: User.new)
  end
  
  it "should list all team transactions" do
    Transfer.build(
      @acc1, @acc2,
      15, "Mensaje de prueba"
    ).execute!

    @team.transactions.size.should == 1
  end
  
end