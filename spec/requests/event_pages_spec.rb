require 'spec_helper'

describe 'EventPages' do

  describe 'GET /newevent' do
    before do
      User.create(name: 'Alpha')
      User.create(name: 'Bravo')
      User.create(name: 'Charlie')
      @user = User.first
      visit newevent_path
    end
    title = '新規イベント作成'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
    end

    it 'はイベント名入力欄を含む' do
      expect(page).to have_selector(:xpath, "//input[@id='event_name']")
    end

    it 'はメモ入力欄を含む' do
      expect(page).to have_selector(:xpath, "//input[@id='event_memo']")
    end

    it 'は開催日入力欄を含む' do
      expect(page).to have_selector(:xpath, "//input[@id='event_date']")
    end

    it 'は参加者選択欄を含む' do
      expect(page).to have_selector(:xpath, "//select[@id='event_participant_ids']")
    end

    it 'は参加者選択肢に登録済ユーザを含む' do
      expect(page).to have_selector(:xpath, "//option[@value='#{@user.id}']")
    end
  end

  describe 'イベント作成機能' do
    before do
      User.create(name: 'Alpha')
      User.create(name: 'Bravo')
      User.create(name: 'Charlie')
      @user = User.first
      visit newevent_path
    end
    let(:submit) { '確定' }

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

      # 本来はイベント一覧ページに遷移する
      # イベント一覧ページができるまではイベント作成画面に戻る
      specify 'イベント作成画面に戻ること' do
        expect(page).to have_title('新規イベント作成')
      end

      specify 'エラーメッセージが表示されないこと' do
        expect(page).not_to have_content('Error')
      end
    end
  end
end
