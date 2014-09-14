require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter)}
  it { should validate_presence_of(:recipient_email)} 
  it { should validate_presence_of(:recipient_name)} 
  it { should validate_presence_of(:message)} 

  it "generates a token when the user is created" do
    invite = Fabricate(:invitation) 
    expect(invite.token).to be_present
  end
end


