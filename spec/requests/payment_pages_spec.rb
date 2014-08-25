require 'spec_helper'

describe 'PaymentPages' do
  describe 'GET /payments/index' do
    before do
      @user = User.create(name: 'Alpha')
      User.create(name: 'Bravo')
      User.create(name: 'Charlie')
      @event = Event.create(name: 'fuga', memo: 'hoge', date: '2014/01/01')
      @event.participants.create(user_id: User.first.id)
      @event.participants.create(user_id: User.second.id)
      @event.participants.create(user_id: User.third.id)
      item = @event.items.create(user_id: User.first.id, memo: 'fuga', price: 123)
      item.payments.create(participant_id: @event.participants.second.id,
                           price: 234, status: false)
      visit payments_path
    end
    title = '支払情報一覧'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
    end

    it 'は支払情報(イベント名)が表示される' do
      expect(page).to have_content('fuga')
    end

    it 'は支払情報(支払元ユーザ名)が表示される' do
      expect(page).to have_content('Bravo')
    end

    it 'は支払情報(支払先ユーザ名)が表示される' do
      expect(page).to have_content('Alpha')
    end

    it 'は支払情報(金額)が表示される' do
      expect(page).to have_content(234)
    end

    it 'は支払情報(精算状況)が表示される' do
      expect(page).to have_content('未精算')
    end

    it 'は「イベントでフィルタ」プルダウンメニューが表示される' do
      expect(page).to have_selector(:xpath, "//select[@id='filter_by_event']")
    end

    it 'は「イベントでフィルタ」選択肢にイベントを含む' do
      expect(page).to have_selector(:xpath, "//option[@value='#{@event.id}'][../@id='filter_by_event']")
    end

    it 'は「ユーザでフィルタ」プルダウンメニューが表示される' do
      expect(page).to have_selector(:xpath, "//select[@id='filter_by_user']")
    end

    it 'は「ユーザでフィルタ」選択肢にユーザを含む' do
      expect(page).to have_selector(:xpath, "//option[@value='#{@user.id}'][../@id='filter_by_user']")
    end

    describe '支払情報が存在しないとき' do
      before do
        Payment.all.each do |payment|
          payment.destroy
        end
        visit payments_path
      end

      it '支払情報がない旨のメッセージが表示されること' do
        expect(page).to have_content('支払情報がありません')
      end
    end
  end
end
