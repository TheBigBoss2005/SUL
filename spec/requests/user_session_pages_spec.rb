require 'spec_helper'

describe 'UserSessionPages' do
  let(:user) { FG.build(:user) }

  describe 'GET /users/sign_in' do
    let(:submit) { 'ログイン' }
    before(:each) do
      visit user_session_path
    end

    it 'はログインの見出しを表示する' do
      expect(page).to have_title('welcome to sul')
      expect(page).to have_content('Welcome to SUL')
    end

    it 'はlogin_idでログインが出来る' do
      user.save
      fill_in 'ログインID or メールアドレス', with: user.login_id
      fill_in 'パスワード', with: user.password
      click_button submit
      expect(page).to have_content('ログインしました')
    end

    it 'はemailでログインが出来る' do
      user.save
      fill_in 'ログインID or メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button submit
      expect(page).to have_content('ログインしました')
    end

    it 'は登録されていないユーザではログイン出来ない' do
      fill_in 'ログインID or メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button submit
      expect(page).to have_content('ログインID or メールアドレスかパスワードが違います。')
    end
  end

  describe 'GET /users/sign_out' do
    let(:submit) { 'Logout' }
    before(:each) do
      @user = FG.create(:user)
      sign_in @user
      visit root_path
    end

    it 'はログアウトが出来てログインフォームに遷移する' do
      click_link submit
      expect(page).to have_content('Welcome to SUL')
    end
  end
end
