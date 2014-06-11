require 'spec_helper'

describe Item do
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event) }
  before do
    @item_from_event = event.items.build(
      memo: 'hoge',
      price: 12_345,
      user_id: user.id)
  end
  before do
    @item_from_user = user.items.build(
      memo: 'hoge',
      price: 12_345,
      event_id: event.id)
  end

  subject { @item_from_event }

  it { should respond_to(:user_id) }
  it { should respond_to(:memo) }
  it { should respond_to(:event_id) }
  it { should respond_to(:price) }
  it { should respond_to(:payments) }

  it { should be_valid }

  describe 'when memo is not present' do
    before { @item_from_event.memo = ' ' }
    it { should_not be_valid }
  end

  describe 'when memo is too long' do
    before { @item_from_event.memo = 'a' * 21 }
    it { should_not be_valid }
  end

  describe 'when memo includes' do

    describe 'word' do
      before { @item_from_event.memo = 'a' }
      it { should be_valid }
    end

    describe 'number' do
      before { @item_from_event.memo = '0' }
      it { should be_valid }
    end

    describe 'kana' do
      before { @item_from_event.memo = 'あ' }
      it { should be_valid }
    end

    describe 'half-kana' do
      before { @item_from_event.memo = 'ｱ' }
      it { should be_valid }
    end

    describe "'-'" do
      before { @item_from_event.memo = '-' }
      it { should be_valid }
    end

    describe "'\u30fc'" do
      before { @item_from_event.memo = 'ー' }
      it { should be_valid }
    end

    describe 'SPACE' do
      before { @item_from_event.memo = 'a b' }
      it { should be_valid }
    end

    describe 'SPACE(zenkaku)' do
      before { @item_from_event.memo = 'a　b' }
      it { should be_valid }
    end

    describe 'non-approved symbol' do
      before { @item_from_event.memo = '%' }
      it { should_not be_valid }
    end

  end

  describe 'user_id' do
    before { @item_from_event.user_id = ' ' }
    it { should_not be_valid }
  end

  describe 'event_id' do
    before { @item_from_event.event_id = ' ' }
    it { should_not be_valid }
  end
end
