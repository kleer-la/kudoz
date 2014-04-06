require 'spec_helper'

describe Transfer do
  
  before(:each) do
    @u1 = User.new
    @u2 = User.new

    @team = Team.new { |t| t.name = "Equipo de Testing" }
    @acc1 = @team.accounts.build(team: @team, user: @u1)
    @acc2 = @team.accounts.build(team: @team, user: @u2)

    @kudozio = User.new { |u| u.is_kudozio = true }
    @kudozio.accounts.build(user: @kudozio)
  end
  
  it "should transfer 15 koinz from a1 to a2" do
    tr = Transfer.new
    tr.origin = @acc1
    tr.destination = @acc2
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    @acc1.balance.should == 85
    @acc2.balance.should == 115
  end
  
  it "should transfer 40 koinz from a2 to a1" do
    tr = Transfer.new
    tr.origin = @acc2
    tr.destination = @acc1
    tr.ammount = 40
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    @acc2.balance.should == 60
    @acc1.balance.should == 140
  end
  
  it "should validate the execution is done from an accounts with enough balance" do
    tr = Transfer.new
    tr.origin = @acc1
    tr.destination = @acc2
    tr.ammount = 200
    tr.message = "Mensaje de prueba"
    expect { tr.execute! }.to raise_error
    
    @acc1.balance.should == 100
    @acc2.balance.should == 100
  end
  
  it "should not validate the execution is done from an accounts with enough balance if Kudozio The Great is the originator" do
    tr = Transfer.new
    tr.origin = @kudozio.accounts.first
    tr.destination = @acc2
    tr.ammount = 20000
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 100
    @acc2.balance.should == 20100
  end
  
  it "should validate the execution is done with a positive amount" do
    tr = Transfer.new
    tr.origin = @acc1
    tr.destination = @acc2
    tr.ammount = -50
    tr.message = "Mensaje de prueba"
    expect { tr.execute! }.to raise_error
    
    @acc1.balance.should == 100
    @acc2.balance.should == 100
  end
  
  it "should not validate the execution is done with a positive amount if Kudozio The Great is the originator" do
    tr = Transfer.new
    tr.origin = @kudozio.accounts.first
    tr.destination = @acc2
    tr.ammount = -50
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 100
    @acc2.balance.should == 50
  end
  
  it "should validate the execution is done inside a single team" do
    tr = Transfer.new
    tr.origin = @acc1
    tr.destination = @acc2
    tr.destination.team = Team.create( name: "Un Equipo Diferente" )
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    expect { tr.execute! }.to raise_error
    
    @acc1.balance.should == 100
    @acc2.balance.should == 100
  end
  
  it "should not validate the execution is done inside a single team if Kudozio The Great is the originator" do
    tr = Transfer.new
    tr.origin = @kudozio.accounts.first
    tr.destination = @acc2
    tr.destination.team = Team.create( name: "Un Equipo Diferente" )
    tr.ammount = 15
    tr.message = "Mensaje de prueba"
    tr.execute!
    
    tr.origin.balance.should == 100
    @acc2.balance.should == 115
  end
  
  it "should valdate that Kudozio The Great cant be the destination" do
     tr = Transfer.new
     tr.origin = @acc1
     tr.destination = @kudozio.accounts.first
     tr.ammount = 50
     tr.message = "Transfiriendo a Kudozio"
     expect { tr.execute! }.to raise_error

     @acc1.balance.should == 100
     tr.destination.balance.should == 100
  end
  
  it "should require an ammount" do
     tr = Transfer.new
     tr.origin = @acc1
     tr.destination = @acc2
     tr.ammount = ""
     expect { tr.execute! }.to raise_error
     
     @acc1.balance.should == 100
     @acc2.balance.should == 100
  end
  
  it "should require a message" do
    tr = Transfer.new
    tr.origin = @acc1
    tr.destination = @acc2
    tr.ammount = 10
    tr.message = ""
    expect { tr.execute! }.to raise_error
    
    @acc1.balance.should == 100
    @acc2.balance.should == 100
  end
  
  it "should have a to_s method" do
    @u1.fname = "Alejandro"
    @u1.lname = "Korn"
    @u2.fname = "Marcos"
    @u2.lname = "Paz"

    tr = Transfer.new
    tr.origin = @acc1
    tr.destination = @acc2
    tr.ammount = 10
    tr.message = "here the message"

    tr.to_s.should == "10 Kudos from Alejandro Korn to Marcos Paz: here the message"
  end
  
  it "should have a to_s method" do
    @u1.fname = "Coronel"
    @u1.lname = "Brandsen"
    @u2.fname = "San"
    @u2.lname = "Clemente"

    tr = Transfer.new
    tr.origin = @acc1
    tr.destination = @acc2
    tr.ammount = 100
    tr.message = "Another Message"

    tr.to_s.should == "100 Kudos from Coronel Brandsen to San Clemente: Another Message"
  end
  
end