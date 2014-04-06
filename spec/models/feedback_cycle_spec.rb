require 'support/active_record'

describe FeedbackCycle do

  before(:each) do
    @u1 = User.new #{ |u| u.id = 101 }
    @u2 = User.new #{ |u| u.id = 102 }
    @u3 = User.new #{ |u| u.id = 103 }

    @team = Team.new { |t| t.name = "Equipo de Testing" }
    @acc1 = @team.accounts.build(balance: 100, team: @team, user: @u1)
    @acc2 = @team.accounts.build(balance: 100, team: @team, user: @u2)
    @acc3 = @team.accounts.build(balance: 100, team: @team, user: @u3)

    kudozio = User.new { |u| u.is_kudozio = true }
    @kudozio_account = kudozio.accounts.build(user: kudozio)

    @fc = FeedbackCycle.new { |fc| fc.team = @team }
  end
  
  it "should have a Kudozio User" do
    @kudozio_account.should_not be nil
  end
  
  context "when starting in fake mode" do
    
    before(:each) do
      @affected_accounts = @fc.start(@kudozio_account)
    end
  
    it "should not modify team members's balances" do
      @fc.team.accounts[0].balance.should == 100
      @fc.team.accounts[1].balance.should == 100
      @fc.team.accounts[2].balance.should == 100
    end
    
    it "should not mark the feedback cycle as started" do
      @fc.started_on.should be nil
    end
    
    it "should return an empty array of affected accounts" do
      @affected_accounts.size.should == 0
    end
  
  end
  
  context "when starting in real mode" do
    
    before(:each) do
      @affected_accounts = @fc.start!(@kudozio_account)
    end
    
    it "should mark the feedback cycle as started" do
      @fc.started_on.should_not be nil
    end
    
    it "should increase team members's balance in 100 kudoz" do
      @fc.team.accounts[0].balance.should == 200
      @fc.team.accounts[1].balance.should == 200
      @fc.team.accounts[2].balance.should == 200
    end
    
    it "should have transfers from Kudozio" do
      @fc.team.accounts[0].transactions.last.origin.user.is_kudozio.should be true
      @fc.team.accounts[1].transactions.last.origin.user.is_kudozio.should be true
      @fc.team.accounts[2].transactions.last.origin.user.is_kudozio.should be true
    end
    
    it "should have transfers of 100 kudoz each" do
      @fc.team.accounts[0].transactions.last.ammount.should == 100
      @fc.team.accounts[1].transactions.last.ammount.should == 100
      @fc.team.accounts[2].transactions.last.ammount.should == 100
    end
    
    it "should return an array of destination accounts" do
      @affected_accounts.size.should == 3
    end
    
  end
  
  context "when finishing in fake mode" do

    it "should not mark the feedback cycle as finished" do
      @fc.finish(@kudozio_account)
      @fc.finished_on.should be nil
    end
    
    it "should return no accounts" do
      @fc.finish(@kudozio_account).size.should == 0
    end
  
  end
  
  context "when finishing in real mode" do
    
    before(:each) do
      @u4 = User.new #{ |u| u.id = 104 }
      @u5 = User.new #{ |u| u.id = 105 }
      @u6 = User.new #{ |u| u.id = 106 }

      @acc4 = @team.accounts.build(balance: 100, team: @team, user: @u4)
      @acc5 = @team.accounts.build(balance: 100, team: @team, user: @u5)
      @acc6 = @team.accounts.build(balance: 100, team: @team, user: @u6)

      @fc.start!(@kudozio_account)

      Transfer.build(
        @acc1, @acc2,
        10, "Mensaje de prueba uno"
      ).execute!

      Transfer.build(
        @acc1, @acc3,
        20, "Mensaje de prueba dos"
      ).execute!
      
      Transfer.build(
        @acc2, @acc3,
        35, "Mensaje de prueba tres"
      ).execute!
      
      Transfer.build(
        @acc3, @acc1,
        40, "Mensaje de prueba cuatro"
      ).execute!
      
      Transfer.build(
        @acc5, @acc1,
        95, "Mensaje de prueba cinco"
      ).execute!
      
      Transfer.build(
        @acc5, @acc2,
        5, "Mensaje de prueba seis"
      ).execute!
      
      Transfer.build(
        @acc6, @acc2,
        130, "Mensaje de prueba siete"
      ).execute!
    end
  
    it "should mark the feedback cycle as finished" do
      @fc.finish!(@kudozio_account)
      
      @fc.finished_on.should_not be nil
    end
    
    it "should increase team members's balance based on feedback done" do
      @fc.finish!(@kudozio_account)
      
      @acc1.balance.should == 165
      @acc2.balance.should == 180
      @acc3.balance.should == 95
    end
    
    it "should remove 200 kudoz from someone that gave nothing away" do
      @fc.finish!(@kudozio_account)
      
      @acc4.balance.should == 0
    end
    
    it "should not remove kudoz from someone that gave all away" do
      @fc.finish!(@kudozio_account)
      
      @acc5.balance.should == 100
    end
    
    it "should not remove kudoz from someone that gave more than 100 kudoz" do
      @fc.finish!(@kudozio_account)
      
      @acc6.balance.should == 70
    end
    
    it "should have 6 positions" do
      @fc.finish!(@kudozio_account)

      @fc.positions.size.should == 6
    end
    
    it "should have positions reflecting the amount of kudoz received" do
      @fc.finish!(@kudozio_account)
      
      @fc.positions.select{ |pos| pos.user.id == @u1.id }.first.received_kudoz.should == 135
      @fc.positions.select{ |pos| pos.user.id == @u3.id }.first.received_kudoz.should == 55
      @fc.positions.select{ |pos| pos.user.id == @u4.id }.first.received_kudoz.should == 0
      @fc.positions.select{ |pos| pos.user.id == @u5.id }.first.received_kudoz.should == 0
      @fc.positions.select{ |pos| pos.user.id == @u6.id }.first.received_kudoz.should == 0
    end
    
    it "should only count 100 of the given kudoz" do
      @fc.finish!(@kudozio_account)
      
      @fc.positions.select{ |pos| pos.user.id == @u2.id }.first.received_kudoz.should == 115
    end
    
    it "should return the accounts that failed to give all kudoz" do
      @fc.finish!(@kudozio_account).size.should == 4
    end
  
  end

end