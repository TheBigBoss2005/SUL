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

  describe 'memoが空の場合' do
    before { @item_from_event.memo = ' ' }
    it { should_not be_valid }
  end

  describe 'memoの長さが20より長い場合' do
    before { @item_from_event.memo = 'a' * 21 }
    it { should_not be_valid }
  end

  describe 'memoに含まれる文字が' do

    describe "'<','>'以外の場合" do
      %w(A あ 0 - = / _ \\ " ').each do |w|
        describe "例:#{w}'" do
          before do
            @item_from_event.memo = w
            @item_from_event.save
          end
          it 'そのまま保存されること' do
            expect(@item_from_event.memo).to eq(w)
          end
        end
      end
    end

    describe "'<'の場合" do
      before do
        @item_from_event.memo = '<'
        @item_from_event.save
      end
      it "'&lt;'に変換されること" do 
        expect(@item_from_event.memo).to eq('&lt;')
      end
    end

    describe "'>'の場合" do
      before do
        @item_from_event.memo = '>'
        @item_from_event.save
      end
      it "'&gt;'に変換されること" do
        expect(@item_from_event.memo).to eq('&gt;')
      end
    end
  end

  describe 'user_idが空の場合' do
    before { @item_from_event.user_id = ' ' }
    it { should_not be_valid }
  end

  describe 'event_idが空の場合' do
    before { @item_from_event.event_id = ' ' }
    it { should_not be_valid }
  end
end
