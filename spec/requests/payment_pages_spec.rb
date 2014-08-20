require 'spec_helper'

describe 'PaymentPages' do
  it 'は未ログインユーザはアクセス出来ない' do
    visit new_event_path
    expect(page).to have_content('Welcome to SUL')
  end

  describe 'GET /payments/index' do
    before do
      sign_in FG.create(:user)
      visit payments_path
    end
    title = '支払情報一覧'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
    end

  end
end
