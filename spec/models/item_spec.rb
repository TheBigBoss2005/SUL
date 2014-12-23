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

  specify { expect(subject).to respond_to(:user_id) }
  specify { expect(subject).to respond_to(:memo) }
  specify { expect(subject).to respond_to(:event_id) }
  specify { expect(subject).to respond_to(:price) }
  specify { expect(subject).to respond_to(:payments) }

  describe Item, '#user_id, #memo, #event_id, #priceが設定済の場合' do
    specify 'validationに成功すること' do
      expect(subject).to be_valid
    end
  end

  describe Item, '#memoが空の場合' do
    before { subject.memo = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Item, '#memoの長さが20より長い場合' do
    before { subject.memo = 'a' * 21 }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Item, '#memoに含まれる文字が' do

    describe "'<','>'以外の場合" do
      %w(A あ 0 - = / _ \\ " ').each do |w|
        describe "例:#{w}'" do
          before do
            subject.memo = w
            subject.save
          end
          it 'そのまま保存されること' do
            expect(subject.memo).to eq(w)
          end
        end
      end
    end

    describe "'<'の場合" do
      before do
        subject.memo = '<'
        subject.save
      end
      it "'&lt;'に変換されること" do
        expect(subject.memo).to eq('&lt;')
      end
    end

    describe "'>'の場合" do
      before do
        subject.memo = '>'
        subject.save
      end
      it "'&gt;'に変換されること" do
        expect(subject.memo).to eq('&gt;')
      end
    end
  end

  describe Item, '#user_idが空の場合' do
    before { subject.user_id = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Item, '#event_idが空の場合' do
    before { subject.event_id = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Item, '#priceが半角数字でない場合' do
    before { subject.price = '１' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Item, '#priceが0以下の場合' do
    before { subject.price = 0 }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe 'Itemオブジェクトを複数取得した場合' do
    it 'はidの降順に並ぶ' do
      Item.destroy_all
      items = Array.new
      3.times { items.push(FG.create(:item, event_id: 1, user_id: 1, price: 1)) }
      expect(Item.all).to eq(items.reverse)
    end
  end
end
