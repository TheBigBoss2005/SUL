require 'spec_helper'

describe 'PaymentPages' do
  describe 'GET /payments/index' do
    before { visit payments_path }
    title = '支払情報一覧'

    it "は'#{title}'の見出しを表示する" do
      expect(page).to have_content(title)
    end

    it "はページタイトルに'#{title}'を含む" do
      expect(page).to have_title(title)
    end

  end
end
