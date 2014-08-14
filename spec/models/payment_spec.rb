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

  specify { expect(subject).to respond_to(:participant_id) }
  specify { expect(subject).to respond_to(:item_id) }
  specify { expect(subject).to respond_to(:price) }
  specify { expect(subject).to respond_to(:status) }

  describe Payment, '#participant_id, #item_id, #priceが設定済の場合' do
    specify 'validationに成功すること' do
      expect(subject).to be_valid
    end
  end

  describe Payment, '#participant_idが空の場合' do
    before { subject.participant_id = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Payment, '#item_idが空の場合' do
    before { subject.item_id = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Payment, '#priceが空の場合' do
    before { subject.price = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe '精算完了の操作をした場合' do
    it 'はstatusがtrueに変更される' do
      subject.finished
      expect(subject.status).to be_true
    end
  end
end
