require 'spec_helper'

describe 'Topページ' do
  it 'は未ログインユーザはアクセス出来ない' do
    visit new_event_path
    expect(page).to have_content('Welcome to SUL')
  end

  describe 'GET /' do
    before(:each) do
      sign_in FG.create(:user)
      visit root_path
    end

    it 'はイベント一覧ページと支払いページへのボタンが表示される' do
      expect(page).to have_content('かねかん')
      expect(page).to have_css('a.btn-warning', text: 'イベント見るよ')
      expect(page).to have_css('a.btn-success', text: '精算するよ')
    end

    it 'の「精算するよ」ボタンを押すと支払一覧ページに遷移する' do
      click_link '精算するよ'
      expect(page).to have_title('支払一覧')
    end
  end
end
