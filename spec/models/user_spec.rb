require 'spec_helper'

describe User do
  
  it "should create a default account upon creation" do
    user = User.create( fname: "Un", lname: "Usuario", email: "un@email.com", provider: "test", uid: "petetetedddd" )
    user.accounts.size.should == 1
  end
  
end
