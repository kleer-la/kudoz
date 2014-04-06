require 'support/active_record'

describe User do
  
  before(:each) do
    @u1 = User.new
    @u2 = User.new
    @u3 = User.new

    @team1 = Team.new { |t| t.name = "Equipo de Testing 1" }
    @acc1 = @team1.accounts.build(team: @team1, user: @u1)
    @acc2 = @team1.accounts.build(team: @team1, user: @u2)

    @team2 = Team.new { |t| t.name = "Equipo de Testing 2" }
    @acc3 = @team2.accounts.build(team: @team2, user: @u1)
    @acc4 = @team2.accounts.build(team: @team2, user: @u3)
  end
  
  it "should list all visible transactions" do
    Transfer.build(
      @acc1, @acc2,
      15, "Mensaje de prueba uno"
    ).execute!

    Transfer.build(
      @acc3, @acc4,
      15, "Mensaje de prueba dos"
    ).execute!
   
    @u1.visible_transactions.size.should == 2
  end
    
end