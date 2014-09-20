require 'spec_helper'

describe 'ItemPages' do
  it 'は未ログインユーザではアクセス出来ない' do
    event = FG.create(:event)
    visit new_event_item_path(event)
    expect(page).to have_content('Welcome to SUL')
  end

  describe 'GET /items/new' do
    before do
      @alpha = FG.create(:user, name: 'Alpha')
      @bravo = FG.create(:user, name: 'Bravo')
      @charlie = FG.create(:user, name: 'Charlie')
      @delta = FG.create(:user, name: 'Delta')
      @echo = FG.create(:user, name: 'Echo')
      sign_in @alpha

      @event = FG.create(:event)
      @participant = FG.create(:participant, event: @event, user: @alpha)
      FG.create(:participant, event: @event, user: @charlie)
      FG.create(:participant, event: @event, user: @echo)

      visit event_path(@event)
      click_link '支払情報を登録するよ'
    end
    title = '支払情報登録'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
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
      expect(page).to have_selector(:xpath, "//option[@value='#{@alpha.id}'][../@id='dest_user_id']")
    end

    it 'は品目入力欄を含む' do
      expect(page).to have_field('品目')
    end

    it 'は金額入力欄を含む' do
      expect(page).to have_field('金額')
    end
  end

  describe '支払情報登録機能' do
    before do
      @alpha = FG.create(:user, name: 'Alpha')
      @bravo = FG.create(:user, name: 'Bravo')
      @charlie = FG.create(:user, name: 'Charlie')
      @delta = FG.create(:user, name: 'Delta')
      @echo = FG.create(:user, name: 'Echo')
      sign_in @alpha

      @event = Event.create(name: 'test event', memo: 'hoge', date: '2014/01/01')
      @event.participants.create(user_id: User.first.id)
      @event.participants.create(user_id: User.third.id)
      @event.participants.create(user_id: User.fifth.id)

      visit event_path(@event)
      click_link '支払情報を登録するよ'
    end

    let(:submit) { '確定' }

    context 'キャンセルボタン押下時' do
      before { click_link 'キャンセル' }

      specify 'イベント参照画面に遷移すること' do
        expect(page).to have_title('イベント参照')
      end
    end

    context '支払情報が無効な変更内容のとき' do
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

    context '支払情報が有効な変更内容(支払元が一人)のとき' do
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

    context '支払情報が有効な変更内容(支払元が複数)のとき' do
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

    context '支払元と支払先が同一ユーザの場合' do
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
