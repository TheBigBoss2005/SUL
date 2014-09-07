require 'spec_helper'

describe 'EventPages' do

  describe 'GET /events/new' do
    before { visit new_event_path }
    title = '新規イベント作成'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
    end

    it 'はイベント名入力欄(空)を含む' do
      expect(page.find_field('Name').text).to be_empty
    end

    it 'はメモ入力欄(空)を含む' do
      expect(page.find_field('Memo').text).to be_empty
    end

    it 'は開催日入力欄(空)を含む' do
      expect(page.find_field('Date').text).to be_empty
    end

    describe '登録済ユーザが存在するとき' do
      before do
        User.create(name: 'Alpha')
        User.create(name: 'Bravo')
        User.create(name: 'Charlie')
        @user = User.first
        visit new_event_path
      end

      it 'は参加者選択欄を含む' do
        expect(page).to have_selector(:xpath, "//select[@id='event_participant_ids']")
      end

      it 'は参加者選択肢に登録済ユーザを含む' do
        expect(page).to have_selector(:xpath, "//option[@value='#{@user.id}']")
      end
    end

    describe '登録済ユーザが存在しないとき' do
      it 'は参加者選択欄を含まない' do
        expect(page).not_to have_selector(:xpath, "//select[@id='event_participant_ids']")
      end

      it 'はユーザ登録メッセージを含む' do
        expect(page).to have_content('ユーザ登録を行ってください')
      end

    end
  end

  describe 'イベント作成機能' do
    before do
      User.create(name: 'Alpha')
      User.create(name: 'Bravo')
      User.create(name: 'Charlie')
      @user = User.first
      visit new_event_path
    end
    let(:submit) { '確定' }
    let(:cancel) { 'キャンセル' }

    describe 'キャンセルボタン押下時' do
      before { click_link cancel }

      specify 'イベントリスト画面に戻ること' do
        expect(page).to have_title('イベントリスト')
      end
    end

    describe '無効な登録内容のとき' do
      it 'イベントが追加されないこと' do
        expect { click_button submit }.not_to change(Event, :count)
      end

      describe '確定ボタン押下時' do
        before { click_button submit }

        specify 'イベント作成画面に戻ること' do
          expect(page).to have_title('新規イベント作成')
        end

        specify 'エラーメッセージが表示されること' do
          expect(page).to have_content('Error')
        end
      end
    end

    describe '有効な登録内容のとき' do
      before do
        fill_in 'Name', with: 'test event'
        fill_in 'Memo', with: 'hoge'
        fill_in 'Date', with: '2014/01/01'
        select @user.name, from: 'event_participant_ids'
      end

      specify 'イベントが追加されること' do
        expect { click_button submit }.to change(Event, :count).by(1)
      end

      specify 'イベント参加者が追加されること' do
        expect { click_button submit }.to change(Participant, :count).by(1)
      end

      specify 'イベント参照画面に遷移すること' do
        click_button submit
        expect(page).to have_title('イベント参照')
      end

      specify 'エラーメッセージが表示されないこと' do
        expect(page).not_to have_content('Error')
      end
    end
  end

  describe 'GET /event/*/edit' do
    before do
      @dest_user = User.create(name: 'Alpha')
      User.create(name: 'Bravo')
      @source_user = User.create(name: 'Charlie')
      User.create(name: 'Delta')
      User.create(name: 'Echo')

      @event = Event.create(name: 'test event', memo: 'hoge', date: '2014/01/01')
      @event.participants.create(user_id: User.first.id)
      @event.participants.create(user_id: User.third.id)
      @event.participants.create(user_id: User.fifth.id)

      @participant = User.first
      @out_of_participant = User.second

      visit edit_event_path(@event)
    end
    title = 'イベント編集'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
    end

    it 'はイベント名入力欄(変更前の値入力済)を含む' do
      expect(page).to have_field('Name', with: @event.name)
    end

    it 'はメモ入力欄(変更前の値入力済)を含む' do
      expect(page).to have_field('Memo', with: @event.memo)
    end

    it 'は開催日入力欄(変更前の値入力済)を含む' do
      expect(page).to have_field('Date', with: @event.formatted_date)
    end

    it 'は参加者選択欄を含む' do
      expect(page).to have_selector(:xpath, "//select[@id='event_participant_ids']")
    end

    it 'は参加者選択肢にイベント未参加の登録済ユーザを含む' do
      expect(page).to have_selector(:xpath, "//option[@value='#{@out_of_participant.id}'][../@id='event_participant_ids']")
    end

    it 'は参加者選択肢にイベント参加済の登録済ユーザを含まない' do
      expect(page).not_to have_selector(:xpath, "//option[@value='#{@participant.id}'][../@id='event_participant_ids']")
    end

    it 'は支払元選択欄を含む' do
      expect(page).to have_selector(:xpath, "//select[@id='source_user_ids']")
    end

    it 'は支払元リストに参加済の参加者を含む' do
      expect(page).to have_selector(:xpath, "//option[@value='#{@event.participants.first.id}'][../@id='source_user_ids']")
    end

    it 'は支払先選択欄を含む' do
      expect(page).to have_selector(:xpath, "//select[@id='dest_user_id']")
    end

    it 'は支払先リストに参加済の参加者を含む' do
      expect(page).to have_selector(:xpath, "//option[@value='#{@participant.id}'][../@id='dest_user_id']")
    end

    it 'は品目入力欄を含む' do
      expect(page).to have_field('品目')
    end

    it 'は金額入力欄を含む' do
      expect(page).to have_field('金額')
    end

    describe '支払情報が未登録のとき' do
      it 'は支払情報が未登録であるメッセージが表示される' do
        expect(page).to have_content('登録済支払情報はありません')
      end
    end

    describe '支払情報が登録済のとき' do
      before do
        @item = @event.items.create(user_id: @event.participants.first.user_id, price: 100, memo: 'fuga')
        @payment = @item.payments.create(price: 100, participant_id: @event.participants.second.id)
        visit edit_event_path(@event)
      end

      it 'は支払情報(品目名)が表示される' do
        expect(page).to have_content(@item.memo)
      end

      it 'は支払情報(支払元ユーザ名)が表示される' do
        expect(page).to have_content(@source_user.name)
      end

      it 'は支払情報(支払先ユーザ名)が表示される' do
        expect(page).to have_content(@dest_user.name)
      end

      it 'は支払情報(金額)が表示される' do
        expect(page).to have_content(@payment.price)
      end

      it 'は支払情報(精算状況)が表示される' do
        expect(page).to have_content('未精算')
      end

    end
  end

  describe 'イベント編集機能' do
    before do
      User.create(name: 'Alpha')
      User.create(name: 'Bravo')
      User.create(name: 'Charlie')
      User.create(name: 'Delta')
      User.create(name: 'Echo')

      @event = Event.create(name: 'test event', memo: 'hoge', date: '2014/01/01')
      @event.participants.create(user_id: User.first.id)
      @event.participants.create(user_id: User.third.id)
      @event.participants.create(user_id: User.fifth.id)

      @participant = User.first
      @out_of_participant = User.second

      visit edit_event_path(@event)
    end

    let(:submit) { '確定' }
    let(:cancel) { 'キャンセル' }

    describe 'キャンセルボタン押下時' do
      before { click_button cancel }

      specify 'イベント参照画面に遷移すること' do
        expect(page).to have_title('イベント参照')
      end
    end

    describe '無効な登録内容のとき' do
      before do
        fill_in 'Name', with: ' '
      end

      it 'イベントが更新されないこと' do
        expect { click_button submit }.not_to change(@event, :updated_at)
      end

      describe '確定ボタン押下時' do
        before { click_button submit }

        specify 'イベント編集画面に戻ること' do
          expect(page).to have_title('イベント編集')
        end

        specify 'エラーメッセージが表示されること' do
          expect(page).to have_content('Error')
        end
      end
    end

    describe 'イベント基本情報が有効な変更内容のとき' do
      before do
        fill_in 'Name', with: 'TEST EVENT'
        select @out_of_participant.name, from: 'event_participant_ids'
        click_button submit
      end

      specify 'イベントが更新されること' do
        expect(Event.find_by(id: @event.id).name).to eq('TEST EVENT')
      end

      specify 'イベント参加者が追加されること' do
        expect(Event.find_by(id: @event.id).users).to include(@out_of_participant)
      end

      specify 'エラーメッセージが表示されないこと' do
        expect(page).not_to have_content('Error')
      end
    end

    describe '支払情報が無効な変更内容のとき' do
      before do
        select @event.users.second.name, from: 'dest_user_id'
        fill_in '品目', with: 'foobar'
        fill_in '金額', with: '1000'
      end

      specify '支払品目が追加されないこと' do
        expect { click_button submit }.not_to change(Item, :count)
      end

      specify '支払情報が追加されないこと' do
        expect { click_button submit }.not_to change(Payment, :count)
      end
    end

    describe '支払情報が有効な変更内容(支払元が一人)のとき' do
      before do
        select @event.users.first.name, from: 'source_user_ids'
        select @event.users.second.name, from: 'dest_user_id'
        fill_in '品目', with: 'foobar'
        fill_in '金額', with: '1000'
      end

      specify '支払品目が１件追加されること' do
        expect { click_button submit }.to change(Item, :count).by(1)
      end

      specify '支払情報が１件追加されること' do
        expect { click_button submit }.to change(Payment, :count).by(1)
      end
    end

    describe '支払情報が有効な変更内容(支払元が複数)のとき' do
      before do
        select @event.users.first.name, from: 'source_user_ids'
        select @event.users.third.name, from: 'source_user_ids'
        select @event.users.second.name, from: 'dest_user_id'
        fill_in '品目', with: 'foobar'
        fill_in '金額', with: '1000'
      end

      specify '支払品目が１件追加されること' do
        expect { click_button submit }.to change(Item, :count).by(1)
      end

      specify '支払情報が複数追加されること' do
        expect { click_button submit }.to change(Payment, :count).by(2)
      end

      specify '支払情報の支払金額が割り勘後の金額で追加されること' do
        click_button submit
        expect(@event.items.first.payments.last.price).to eq(500)
      end
    end

    describe '支払元と支払先が同一ユーザの場合' do
      before do
        select @event.users.first.name, from: 'source_user_ids'
        select @event.users.first.name, from: 'dest_user_id'
        fill_in '品目', with: 'foobar'
        fill_in '金額', with: '1000'
        click_button submit
      end

      specify '支払情報が精算済で追加されること' do
        expect(@event.items.first.payments.last.status).to eq(true)
      end
    end
  end
end
