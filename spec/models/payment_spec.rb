require 'spec_helper'

describe Payment do
  let(:item) { FactoryGirl.create(:item, user_id: 1, event_id: 1) }
  let(:participant) { FactoryGirl.create(:participant, user_id: 1, event_id: 1) }
  before do
    @payment_from_item = item.payments.build(
      participant_id: 1,
      price: 12_345,
      status: false)
    @payment_from_participant = participant.payments.build(
      item_id: 1,
      price: 12_345,
      status: false)
  end

  subject { @payment_from_item }

  it { should respond_to(:participant_id) }
  it { should respond_to(:item_id) }
  it { should respond_to(:price) }
  it { should respond_to(:status) }

  it { should be_valid }
end
