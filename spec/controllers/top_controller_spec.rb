require 'spec_helper'

describe TopController do

  describe "トップページ" do
    it "はイベント一覧ページと支払いページへのボタンが表示される" do
       visit root_path
       expect(page).to have_content('')
    end
  end

end
