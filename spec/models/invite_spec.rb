require 'spec_helper'

describe Invite do
  
  it "should atumatically generate a UUID on creation" do
    i = Invite.create( guest_email: "martin.alaimo@kleer.la", message: "un mensaje" )
    
    i.uuid.nil?.should be false
    i.uuid.length.should == 36
  end
  
#  it "should invite the guest" do
#    user = User.create( fname: "Martin", lname: "Alaimo", email: "martin.alaimo@kleer.la" )
#    account = Account.create( balance: 100 )
#    team = Team.create( name: "Testing Team" )
#    account.team = team
#    account.save!
#    user.accounts << account
#    user.save!
#    
#    invite = Invite.create( guest_email: "malaimo@gmail.com", message: "Invitación de prueba" )
#    invite.user = user
#    invite.team = team
#    invite.invite_guest!.should_not be nil
#    
#  end
  
end
