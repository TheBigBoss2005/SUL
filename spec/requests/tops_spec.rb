require 'spec_helper'

describe 'Topページ' do
  describe 'GET /' do
    it 'はイベント一覧ページと支払いページへのボタンが表示される' do
      visit root_path
      expect(page).to have_content('かねかん')
      expect(page).to have_css('a.btn-warning', text: 'イベント見るよ')
      expect(page).to have_css('a.btn-success', text: '清算するよ')
    end
  end
end
