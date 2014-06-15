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

    describe 'non-HTML-tag-symbol' do
      %w(A Ａ あ ア ｱ 亜 0 ０ - ー = ＝ / _ \\ ? % \" \').each do |w|
        describe "'#{w}'" do
          before do
            @item_from_event.memo = w
            @item_from_event.save
          end
          specify { expect(@item_from_event.memo).to eq(w) }
        end
      end
    end

    describe "HTML-tag-symbol '<'" do
      before do
        @item_from_event.memo = '<'
        @item_from_event.save
      end
      specify { expect(@item_from_event.memo).to eq('&lt;') }
    end

    describe "HTML-tag-symbol '>'" do
      before do
        @item_from_event.memo = '>'
        @item_from_event.save
      end
      specify { expect(@item_from_event.memo).to eq('&gt;') }
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
