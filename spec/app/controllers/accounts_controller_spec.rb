require 'spec_helper'

describe "AccountsController" do
  before do
    get "/accounts/12/show"
  end

  it "returns hello world"
end
