require 'spec_helper'

describe 'Layouts' do
  before(:each) { visit root_path }
  describe 'ヘッダーレイアウト' do
    it 'はアプリケーション名が含まれる' do
      expect(page).to have_content('SUL')
    end
  end

  describe 'フッターレイアウト' do
    it 'はチーム名が含まれる' do
      expect(page).to have_content('TBB')
    end
  end
end
