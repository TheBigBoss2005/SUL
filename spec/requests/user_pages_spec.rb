require 'spec_helper'

describe 'UserPages' do
  describe 'GET /users/edit' do
    let(:submit) { '更新する' }
    before(:each) do
      @user = FG.create(:user)
      sign_in @user
      visit edit_user_registration_path
    end

    it 'はユーザ情報変更画面が表示される' do
      expect(page).to have_content('ユーザ情報変更')
      expect(page).to have_selector(:xpath, "//input[@id='user_name'][@value='#{@user.name}']")
      expect(page).to have_selector(:xpath, "//input[@id='user_login_id'][@value='#{@user.login_id}']")
      expect(page).to have_selector(:xpath, "//input[@id='user_email'][@value='#{@user.email}']")
    end

    it 'はユーザ情報が変更される' do
      expect(page).to have_content('ユーザ情報変更')
      fill_in '現在のパスワード', with: @user.password
      click_button submit
      expect(page).to have_content('ユーザー情報を変更しました')
    end

    it 'はvalidationに引っかかる場合はユーザ情報が変更されない' do
      expect(page).to have_content('ユーザ情報変更')
      fill_in '名前', with: ''
      fill_in 'ログインID', with: ''
      fill_in 'メールアドレス', with: ''
      click_button submit
      expect(page).to have_content('メールアドレスを入力してください')
      expect(page).to have_content('名前を入力してください')
      expect(page).to have_content('ログインIDは入力が必須です')
      expect(page).to have_content('現在のパスワードを入力してください')
    end
  end
end
