require 'spec_helper'

describe 'EventPages' do

  describe 'GET /newevent' do
    before { visit newevent_path }
    title = '新規イベント作成'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
    end
  end

  describe 'イベント作成機能' do
    before { visit newevent_path }
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
      end

      specify 'イベントが追加されること' do
        expect { click_button submit }.to change(Event, :count).by(1)
      end

      specify 'イベント作成画面に戻ること' do
        expect(page).to have_title('新規イベント作成')
      end

      specify 'エラーメッセージが表示されないこと' do
        expect(page).not_to have_content('Error')
      end
    end
  end
end
