require 'spec_helper'

describe FeedbackCycle do
  before(:each) do
    @team = Team.create(name: "Un Equipo Para Probar")
    @u1 = User.create(fname: "Marcos", lname: "Paz 1", email: "m.alaimo@gmail.com", accounts: [ Account.create( balance: 100, team: @team ) ] )
    @u2 = User.create(fname: "Marcos", lname: "Paz 2", email: "ma.laimo@gmail.com", accounts: [ Account.create( balance: 100, team: @team ) ] )
    @u3 = User.create(fname: "Marcos", lname: "Paz 3", email: "mal.aimo@gmail.com", accounts: [ Account.create( balance: 100, team: @team ) ] )
    
    @fc = FeedbackCycle.create( team: @team )
  end
  
  it "should have a Kudozio User" do
    kudozio = User.where( "is_kudozio = ?", true ).first
    kudozio.should_not be nil
  end
  
  context "when starting in fake mode" do
    
    before(:each) do
      @affected_accounts = @fc.start
    end
  
    it "should not modify team members's balances" do
      @fc.team.accounts[0].balance.should == 100
      @fc.team.accounts[1].balance.should == 100
      @fc.team.accounts[2].balance.should == 100
    end
    
    it "should not mark the feedback cycle as started" do
      @fc.started_on.should be nil
    end
    
    it "should return an empty array of accounts" do
      @affected_accounts.count.should == 0
    end
  
  end
  
  context "when starting in real mode" do
    
    before(:each) do
      @affected_accounts = @fc.start!
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
      @affected_accounts.count.should == 3
    end
    
  end
  
  context "when finishing in fake mode" do

    it "should not mark the feedback cycle as finished" do
      @fc.finish
      @fc.finished_on.should be nil
    end
    
    it "should return no accounts" do
      @fc.finish.count.should == 0
    end
  
  end
  
  context "when finishing in real mode" do
    
    before(:each) do
      
      @u4 = User.create(fname: "Marcos", lname: "Paz 4", email: "mala.imo@gmail.com", accounts: [ Account.create( balance: 100, team: @team ) ] )
      @u5 = User.create(fname: "Marcos", lname: "Paz 5", email: "malai.mo@gmail.com", accounts: [ Account.create( balance: 100, team: @team ) ] )
      @u6 = User.create(fname: "Marcos", lname: "Paz 5", email: "malai.mo@gmail.com", accounts: [ Account.create( balance: 100, team: @team ) ] )
      
      @fc.start!
      
      @u1.reload
      @u2.reload
      @u3.reload
      @u4.reload
      @u5.reload
      @u6.reload
      
      
      tr = Transfer.new
      tr.origin = @u1.accounts.first
      tr.destination = @u2.accounts.first
      tr.ammount = 10
      tr.message = "Mensaje de prueba uno"
      tr.execute!
    
      
      tr = Transfer.new
      tr.origin = @u1.accounts.first
      tr.destination = @u3.accounts.first
      tr.ammount = 20
      tr.message = "Mensaje de prueba dos"
      tr.execute!

      
      tr = Transfer.new
      tr.origin = @u2.accounts.first
      tr.destination = @u3.accounts.first
      tr.ammount = 35
      tr.message = "Mensaje de prueba tres"
      tr.execute!
    
      
      tr = Transfer.new
      tr.origin = @u3.accounts.first
      tr.destination = @u1.accounts.first
      tr.ammount = 40
      tr.message = "Mensaje de prueba cuatro"
      tr.execute!
      
      tr = Transfer.new
      tr.origin = @u5.accounts.first
      tr.destination = @u1.accounts.first
      tr.ammount = 95
      tr.message = "Mensaje de prueba cuatro"
      tr.execute!
      
      tr = Transfer.new
      tr.origin = @u5.accounts.first
      tr.destination = @u2.accounts.first
      tr.ammount = 5
      tr.message = "Mensaje de prueba cuatro"
      tr.execute!
      
      tr = Transfer.new
      tr.origin = @u6.accounts.first
      tr.destination = @u2.accounts.first
      tr.ammount = 130
      tr.message = "Mensaje de prueba cuatro"
      tr.execute!
    end
  
    it "should mark the feedback cycle as finished" do
      @fc.finish!
      
      @fc.finished_on.should_not be nil
    end
    
    it "should increase team members's balance based on feedback done" do
      @fc.finish!
      
      @u1.reload
      @u2.reload
      @u3.reload
      
      @u1.accounts.first.balance.should == 165
      @u2.accounts.first.balance.should == 180
      @u3.accounts.first.balance.should == 95
    end
    
    it "should remove 200 kudoz from someone that gave nothing away" do
      @fc.finish!
      
      @u4.reload
      @u4.accounts.first.balance.should == 0
    end
    
    it "should not remove kudoz from someone that gave all away" do
      @fc.finish!
      
      @u5.reload
      @u5.accounts.first.balance.should == 100
    end
    
    it "should not remove kudoz from someone that gave more than 100 kudoz" do
      @fc.finish!
      
      @u6.reload
      @u6.accounts.first.balance.should == 70
    end
    
    it "should have 6 positions" do
      @fc.finish!
      
      @fc.positions.count.should == 6
    end
    
    it "should have positions reflecting the amount of kudoz received" do
      @fc.finish!
      
      @fc.positions.select{ |pos| pos.user.id == @u1.id }.first.received_kudoz.should == 135
      @fc.positions.select{ |pos| pos.user.id == @u3.id }.first.received_kudoz.should == 55
      @fc.positions.select{ |pos| pos.user.id == @u4.id }.first.received_kudoz.should == 0
    end
    
    it "should only count 100 of the given kudoz" do
      @fc.finish!
      
      @fc.positions.select{ |pos| pos.user.id == @u2.id }.first.received_kudoz.should == 115
    end
    
    it "should return the accounts that failed to give all kudoz" do
      @fc.finish!.count.should == 4
    end
  
  end
  
  
  
  
end
