require 'spec_helper'

describe Invite do
  
  it "should atumatically generate a UUID on creation" do
    i = Invite.create( guest_email: "martin.alaimo@kleer.la", message: "un mensaje" )
    
    i.uuid.nil?.should be false
    i.uuid.length.should == 36
  end
  
  it "should require an email" do
    i = Invite.create( message: "un mensaje" )
    i.valid?.should be false
  end

  it "should require a message" do
    i = Invite.create( guest_email: "martin.alaimo@kleer.la" )
    i.valid?.should be false
  end

  it "should require a valid email" do
    i = Invite.create( guest_email: "cualquier cosa", message: "un mensaje" )
    i.valid?.should be false  
  end
  
end
