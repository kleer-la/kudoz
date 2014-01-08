require 'spec_helper'

describe "AccountsController" do
  before do
    get "/accounts/12/show"
  end

  it "returns hello world" do
    last_response.body.should == "Hello World"
  end
end
