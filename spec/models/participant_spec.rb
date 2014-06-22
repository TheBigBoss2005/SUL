require 'spec_helper'

describe Participant do
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event) }
  before { @participant_from_event = event.participants.build(user_id: user.id) }
  before { @participant_from_user = user.participants.build(event_id: event.id) }

  subject { @participant_from_event }

  specify { expect(subject).to respond_to(:user_id) }
  specify { expect(subject.user).to eq(user) }

  specify { expect(subject).to respond_to(:event_id) }
  specify { expect(subject.event).to eq(event) }

  specify { expect(subject).to respond_to(:payments) }

  describe Participant, '#user_id, #event_idが設定済の場合' do
    specify 'validationに成功すること' do
      expect(subject).to be_valid
    end
  end

  describe Participant, '#user_idが空の場合' do
    before { subject.user_id = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Participant, '#event_idが空の場合' do
    before { subject.event_id = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end
end
