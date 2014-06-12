require 'spec_helper'

describe 'Layouts' do
  describe 'ヘッダーレイアウト' do
    it 'はアプリケーション名が含まれる' do
      visit root_path
      expect(page).to have_content('SUL')
    end
  end

  describe 'フッターレイアウト' do
    it 'はチーム名が含まれる' do
      visit root_path
      expect(page).to have_content('TBB')
    end
  end
end
