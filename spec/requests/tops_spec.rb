require 'spec_helper'

describe 'Topページ' do
  describe 'GET /' do
    it 'はイベント一覧ページと支払いページへのボタンが表示される' do
      visit root_path
      expect(page).to have_content('かねかん')
      expect(page).to have_css('a.btn-warning', text: 'イベント見るよ')
      expect(page).to have_css('a.btn-success', text: '精算するよ')
    end

    it 'の「精算するよ」ボタンを押すと支払情報一覧ページに遷移する' do
      visit root_path
      click_link '精算するよ'
      expect(page).to have_title('支払情報一覧')
    end
  end
end
