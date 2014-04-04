require 'spec_helper'

describe Invite do
  
  it "should atumatically generate a UUID on creation" do
    invite = Invite.new { |i|
      i.guest_email = "martin.alaimo@kleer.la"
      i.message = "un mensaje"
    }
    
    invite.uuid.nil?.should be false
    invite.uuid.length.should == 36
  end
  
  it "should require an email" do
    invite = Invite.new { |i| i.message = "un mensaje" }

    invite.valid?.should be false
  end

  it "should require a message" do
    invite = Invite.new { |i| i.guest_email = "martin.alaimo@kleer.la" }

    invite.valid?.should be false
  end

  it "should require a valid email" do
    invite = Invite.new { |i|
      i.guest_email = "cualquier cosa"
      i.message = "un mensaje"
    }

    invite.valid?.should be false  
  end
  
end