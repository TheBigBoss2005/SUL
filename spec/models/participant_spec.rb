require 'spec_helper'

describe Participant do
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event) }
  before { @participant_from_event = event.participants.build(user_id: user.id) }
  before { @participant_from_user = user.participants.build(event_id: event.id) }

  subject { @participant_from_event }

  it { should respond_to(:user_id) }
  its(:user) { should eq(user) }

  it { should respond_to(:event_id) }
  its(:event) { should eq(event) }

  it { should respond_to(:payments) }

  it { should be_valid }

  describe 'user_idが空の場合' do
    before { @participant_from_event.user_id = ' ' }
    it { should_not be_valid }
  end

  describe 'event_idが空の場合' do
    before { @participant_from_event.event_id = ' ' }
    it { should_not be_valid }
  end
end
