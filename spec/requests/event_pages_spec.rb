require 'spec_helper'

describe 'EventPages' do
  before(:each) do
    @label_name = 'イベント名'
    @label_memo = '概要'
    @label_date = '開催日'
    @label_participant = '参加者'
  end

  it 'は未ログインユーザではアクセス出来ない' do
    visit new_event_path
    expect(page).to have_content('Welcome to SUL')
  end

  describe 'GET /events/new' do
    before(:each) do
      @alpha = FG.create(:user, name: 'Alpha')
      @bravo = FG.create(:user, name: 'Bravo')
      @charlie = FG.create(:user, name: 'Charlie')
      @delta = FG.create(:user, name: 'Delta')
      @echo = FG.create(:user, name: 'Echo')
      sign_in @alpha
      visit new_event_path
    end
    after(:each) { User.destroy_all }

    describe '戻るボタン押下時' do
      before { click_on '戻る' }

      specify 'イベント参照画面に戻ること' do
        expect(page).to have_title('イベント一覧')
      end
    end

    describe 'パン屑のイベント一覧押下時' do
      it 'はイベント一覧画面に遷移する' do
        click_on 'イベント一覧'
        expect(page).to have_title('イベント一覧')
      end
    end

    title = 'イベント作成'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
    end

    it 'はイベント名入力欄(空)を含む' do
      expect(page.find_field(@label_name).text).to be_empty
    end

    it 'はメモ入力欄(空)を含む' do
      expect(page.find_field(@label_memo).text).to be_empty
    end

    it 'は開催日入力欄(空)を含む' do
      expect(page.find_field(@label_date).text).to be_empty
    end

    describe '登録済ユーザが存在するとき' do
      it 'は参加者選択欄を含む' do
        expect(page).to have_selector(:xpath, "//select[@id='event_participant_ids']")
      end

      it 'は参加者選択肢に登録済ユーザを含む' do
        expect(page).to have_selector(:xpath, "//option[@value='#{@alpha.id}']")
      end
    end

    describe '登録済ユーザが存在しないとき' do
      before(:each) do
        User.delete_all
        visit new_event_path
      end

      it 'は参加者選択欄を含まない' do
        expect(page).not_to have_selector(:xpath, "//select[@id='event_participant_ids']")
      end

      it 'はログインページに遷移する' do
        expect(page).to have_content('Welcome to SUL')
      end

    end
  end

  describe 'イベント作成機能' do
    before do
      @alpha = FG.create(:user, name: 'Alpha')
      sign_in @alpha
      visit new_event_path
    end

    let(:submit) { '確定' }
    let(:cancel) { '戻る' }

    describe 'キャンセルボタン押下時' do
      before { click_link cancel }

      specify 'イベント一覧画面に戻ること' do
        expect(page).to have_title('イベント一覧')
      end
    end

    describe '無効な登録内容のとき' do
      it 'イベントが追加されないこと' do
        expect { click_button submit }.not_to change(Event, :count)
      end

      describe '確定ボタン押下時' do
        before { click_button submit }

        specify 'イベント作成画面に戻ること' do
          expect(page).to have_title('イベント作成')
        end

        specify 'エラーメッセージが表示されること' do
          expect(page).to have_content('Error')
        end
      end
    end

    describe '有効な登録内容のとき' do
      before do
        fill_in @label_name, with: 'test event'
        fill_in @label_memo, with: 'hoge'
        fill_in @label_date, with: '2014/01/01'
        select @alpha.name, from: 'event_participant_ids'
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

  describe 'GET /event/' do
    before(:each)  do
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
      @participant = User.first
      @out_of_participant = User.second

      visit events_path
    end
    after(:each) { User.destroy_all }
    it 'はイベント名が正しく表示されていること' do
      expect(page).to have_content('test event')
    end
    it 'はイベント詳細が正しく表示されていること' do
      expect(page).to have_content('hoge')
    end
    it 'はイベント日が正しく表示されていること' do
      expect(page).to have_content('2014/01/01')
    end
    it 'はイベント参加者１が正しく表示されていること' do
      expect(page).to have_content('Alpha')
    end
    it 'はイベント参加者2が正しく表示されていること' do
      expect(page).to have_content('Charlie')
    end
    it 'はイベント参加者3が正しく表示されていること' do
      expect(page).to have_content('Echo')
    end
    it 'はイベント参加者4が表示されないこと' do
      expect(page).not_to have_content('Bravo')
    end
    it 'はイベント参加者5が表示されないこと' do
      expect(page).not_to have_content('Delta')
    end

    describe 'イベントを作るよボタン押下時' do
      before do
        click_link 'イベントを作るよ'
      end

      specify 'イベント作成画面に遷移すること' do
        expect(page).to have_title('イベント作成')
      end
    end

    describe '詳細リンク押下時' do
      before do
        click_link '詳細'
      end

      it 'はイベント名が正しく表示されていること' do
        expect(page).to have_content('test event')
      end
      it 'はイベント詳細が正しく表示されていること' do
        expect(page).to have_content('hoge')
      end
      it 'はイベント日が正しく表示されていること' do
        expect(page).to have_content('2014/01/01')
      end
      it 'はイベント参加者１が正しく表示されていること' do
        expect(page).to have_content('Alpha')
      end
      it 'はイベント参加者2が正しく表示されていること' do
        expect(page).to have_content('Charlie')
      end
      it 'はイベント参加者3が正しく表示されていること' do
        expect(page).to have_content('Echo')
      end
      it 'は支払情報が未登録であるメッセージが表示されていること' do
        expect(page).to have_content('登録済支払情報はありません')
      end
    end

    describe '詳細ボタン押下時(支払情報ありのとき)' do
      before do
        item = @event.items.create(user_id: @alpha.id, memo: 'fuga', price: 1234)
        @p1 = item.payments.create(participant_id: @event.participants.second.id,
                                   price: 1000, status: false)
        @p2 = item.payments.create(participant_id: @event.participants.first.id,
                                   price: 234, status: true)
        click_link '詳細'
      end

      it 'は品目が表示されていること' do
        expect(page).to have_content('fuga')
      end

      it '金額が表示されていること' do
        expect(page).to have_content('1,000')
        expect(page).to have_content('234')
      end

      it 'は精算状況が表示されていること' do
        expect(page).to have_content('未精算')
        expect(page).to have_content('精算済')
      end
    end
  end

  describe 'GET /event/:id/edit' do
    before do
      @alpha = FG.create(:user, name: 'Alpha')
      @bravo = FG.create(:user, name: 'Bravo')
      @charlie = FG.create(:user, name: 'Charlie')
      @delta = FG.create(:user, name: 'Delta')
      @echo = FG.create(:user, name: 'Echo')
      sign_in @alpha

      @dest_user = @alpha
      @source_user = @charlie

      @event = FG.create(:event)
      @participant = FG.create(:participant, event: @event, user: @alpha)
      FG.create(:participant, event: @event, user: @charlie)
      FG.create(:participant, event: @event, user: @echo)

      @out_of_participant = @bravo

      visit edit_event_path(@event)
    end

    describe '戻るボタン押下時' do
      before { click_on '戻る' }

      specify 'イベント参照画面に戻ること' do
        expect(page).to have_title('イベント参照')
      end
    end

    describe 'パン屑のイベント参照押下時' do
      it 'はイベント参照画面に遷移する' do
        click_on 'イベント参照'
        expect(page).to have_title('イベント参照')
      end
    end

    title = 'イベント編集'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
    end

    it 'はイベント名入力欄(変更前の値入力済)を含む' do
      expect(page).to have_field(@label_name, with: @event.name)
    end

    it 'はメモ入力欄(変更前の値入力済)を含む' do
      expect(page).to have_field(@label_memo, with: @event.memo)
    end

    it 'は開催日入力欄(変更前の値入力済)を含む' do
      expect(page).to have_field(@label_date, with: @event.formatted_date)
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
  end

  describe 'イベント編集機能' do
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

      @participant = User.first
      @out_of_participant = User.second

      visit edit_event_path(@event)
    end

    let(:submit) { '確定' }
    let(:cancel) { '戻る' }

    context '戻るボタン押下時' do
      before { click_on '戻る' }

      specify 'イベント参照画面に遷移すること' do
        expect(page).to have_title('イベント参照')
      end
    end

    context '無効な登録内容のとき' do
      before do
        fill_in @label_name, with: ' '
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

    context 'イベント基本情報が有効な変更内容のとき' do
      before do
        fill_in @label_name, with: 'TEST EVENT'
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
  end
end
