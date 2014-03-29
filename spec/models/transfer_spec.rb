require 'spec_helper'

describe Transfer do
  
  before(:each) do
    team = Team.create( name: "Equipo de Testing" )
    @u1 = User.create( accounts: [ Account.create( team: team ) ] )
    @u2 = User.create( accounts: [ Account.create( team: team ) ] )
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
  
  it "should validate the execution is done from an accounts with enough balance" do
    tr = Transfer.new
    tr.origin = @u1.accounts.first
    tr.destination = @u2.accounts.first
    tr.ammount = 200
    tr.message = "Mensaje de prueba"
    expect { tr.execute! }.to raise_error
    
    tr.origin.balance.should == 100
    tr.destination.balance.should == 100
  end
  
  it "should not validate the execution is done from an accounts with enough balance if Kudozio The Great is the originator" do
    kudozio = User.where( "is_kudozio = ?", true ).first
    
    tr = Transfer.new
    tr.origin = kudozio.accounts.first
    tr.destination = @u2.accounts.first
    tr.ammount = 20000
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 100
    tr.destination.balance.should == 20100
  end
  
  it "should validate the execution is done with a positive amount" do
    tr = Transfer.new
    tr.origin = @u1.accounts.first
    tr.destination = @u2.accounts.first
    tr.ammount = -50
    tr.message = "Mensaje de prueba"
    expect { tr.execute! }.to raise_error
    
    tr.origin.balance.should == 100
    tr.destination.balance.should == 100
  end
  
  it "should not validate the execution is done with a positive amount if Kudozio The Great is the originator" do
    kudozio = User.where( "is_kudozio = ?", true ).first
    
    tr = Transfer.new
    tr.origin = kudozio.accounts.first
    tr.destination = @u2.accounts.first
    tr.ammount = -50
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 100
    tr.destination.balance.should == 50
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
  
  it "should not validate the execution is done inside a single team if Kudozio The Great is the originator" do
    kudozio = User.where( "is_kudozio = ?", true ).first
    
    tr = Transfer.new
    tr.origin = kudozio.accounts.first
    tr.destination = @u2.accounts.first
    tr.destination.team = Team.create( name: "Un Equipo Diferente" )
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 100
    tr.destination.balance.should == 115
  end
  
  it "should valdate that Kudozio The Great cant be the destination" do
     kudozio = User.where( "is_kudozio = ?", true ).first
    
     tr = Transfer.new
     tr.origin = @u1.accounts.first
     tr.destination = kudozio.accounts.first
     tr.ammount = 50
     tr.message = "Transfiriendo a Kudozio"
     expect { tr.execute! }.to raise_error

     tr.origin.balance.should == 100
     tr.destination.balance.should == 100
  end
  
  it "should require an ammount" do
     tr = Transfer.new
     tr.origin = @u1.accounts.first
     tr.destination = @u2.accounts.first
     tr.ammount = ""
     expect { tr.execute! }.to raise_error
     
     tr.origin.balance.should == 100
     tr.destination.balance.should == 100
  end
  
  it "should require a message" do
    tr = Transfer.new
    tr.origin = @u1.accounts.first
    tr.destination = @u2.accounts.first
    tr.ammount = 10
    tr.message = ""
    expect { tr.execute! }.to raise_error
    
    tr.origin.balance.should == 100
    tr.destination.balance.should == 100
  end
  
  it "should have a to_s method" do
    tr = Transfer.new
    tr.origin = @u1.accounts.first
    tr.destination = @u2.accounts.first
    @u1.fname = "Alejandro"
    @u1.lname = "Korn"
    @u2.fname = "Marcos"
    @u2.lname = "Paz"
    @u1.save!
    @u2.save!
    tr.ammount = 10
    tr.message = "here the message"
    tr.to_s.should == "10 Kudos from Alejandro Korn to Marcos Paz: here the message"
  end
  
  it "should have a to_s method" do
    tr = Transfer.new
    tr.origin = @u1.accounts.first
    tr.destination = @u2.accounts.first
    @u1.fname = "Coronel"
    @u1.lname = "Brandsen"
    @u2.fname = "San"
    @u2.lname = "Clemente"
    @u1.save!
    @u2.save!
    tr.ammount = 100
    tr.message = "Another Message"
    tr.to_s.should == "100 Kudos from Coronel Brandsen to San Clemente: Another Message"
  end
end