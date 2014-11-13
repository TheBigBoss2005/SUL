require 'spec_helper'

describe 'EventPages' do
  before(:each) do
    @label_name = 'イベント名'
    @label_memo = '概要'
    @label_date = '開催日'
    @label_participant = '参加者'
    @alpha = FG.create(:user, name: 'Alpha')
    @bravo = FG.create(:user, name: 'Bravo')
    @charlie = FG.create(:user, name: 'Charlie')
    @delta = FG.create(:user, name: 'Delta')
    @echo = FG.create(:user, name: 'Echo')
  end

  it 'は未ログインユーザではアクセス出来ない' do
    visit new_event_path
    expect(page).to have_content('Welcome to SUL')
  end

  describe 'GET /events/new' do
    before(:each) do
      sign_in @alpha
      visit new_event_path
    end
    after(:each) { User.destroy_all }

    describe '戻るボタン押下時' do
      before { click_on '戻る' }

      it 'イベント参照画面に戻ること' do
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
      sign_in @alpha
      visit new_event_path
    end

    let(:submit) { '確定' }
    let(:cancel) { '戻る' }

    describe 'キャンセルボタン押下時' do
      before { click_link cancel }

      it 'イベント一覧画面に戻ること' do
        expect(page).to have_title('イベント一覧')
      end
    end

    describe '無効な登録内容のとき' do
      it 'イベントが追加されないこと' do
        expect { click_button submit }.not_to change(Event, :count)
      end

      describe '確定ボタン押下時' do
        before { click_button submit }

        it 'イベント作成画面に戻ること' do
          expect(page).to have_title('イベント作成')
        end

        it 'エラーメッセージが表示されること' do
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

      it 'イベントが追加されること' do
        expect { click_button submit }.to change(Event, :count).by(1)
      end

      it 'イベント参加者が追加されること' do
        expect { click_button submit }.to change(Participant, :count).by(1)
      end

      it 'イベント参照画面に遷移すること' do
        click_button submit
        expect(page).to have_title('イベント参照')
      end

      it 'エラーメッセージが表示されないこと' do
        expect(page).not_to have_content('Error')
      end
    end
  end

  describe 'GET /event/:id/edit' do
    before do
      sign_in @alpha

      @event = FG.create(:event)
      @participant = FG.create(:participant, event: @event, user: @alpha)
      FG.create(:participant, event: @event, user: @charlie)
      FG.create(:participant, event: @event, user: @echo)

      @out_of_participant = @bravo

      visit edit_event_path(@event)
    end

    describe '戻るボタン押下時' do
      before { click_on '戻る' }

      it 'イベント参照画面に戻ること' do
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

  describe 'GET /events/:id' do
    before do
      sign_in @alpha

      @event = Event.create(name: 'test event', memo: 'hoge', date: '2014/01/01')
      @event.participants.create(user: User.first)
      @event.participants.create(user: User.second)

      visit event_path(@event)
    end

    context 'イベント編集ボタン押下時' do
      before { click_on 'イベントを編集するよ' }

      it 'イベント編集画面に遷移すること' do
        expect(page).to have_title('イベント編集')
      end
    end

    context '支払登録ボタン押下時' do
      before { click_on '支払を登録するよ' }

      it '支払登録画面に遷移すること' do
        expect(page).to have_title('支払登録')
      end
    end

    context '精算ボタン押下時' do
      before do
        click_on '精算するよ'
        @other_event = Event.create(name: 'other event', memo: 'hoge', date: '2014/01/01')
      end

      it '支払一覧画面に遷移してイベントでフィルタされていること' do
        expect(page).to have_title('支払一覧')
        expect(page).to have_content(@event.name)
        expect(page).not_to have_content(@other_event.name)
      end
    end

    context '戻るボタン押下時' do
      before { click_on '戻る' }

      it 'イベント一覧画面に遷移すること' do
        expect(page).to have_title('イベント一覧')
      end
    end

    it 'はページタイトルが表示される' do
      expect(page).to have_content('イベント参照')
    end

    context 'イベント情報の詳細画面を開いた場合' do
      it 'はイベント情報とボタンが参照できる' do
        expect(page).to have_content(@event.name)
        expect(page).to have_content(@event.memo)
        expect(page).to have_content(@event.formatted_date)
        expect(page).to have_content(User.first.name)
        expect(page).to have_content(User.second.name)
      end
    end
  end
end
