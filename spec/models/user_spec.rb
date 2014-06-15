require 'spec_helper'

describe User do
  before do
    @user = User.new(name: 'Taro Yamada')
  end

  subject { @user }

  specify { expect(subject).to respond_to(:name) }
  specify { expect(subject).to respond_to(:participants) }
  specify { expect(subject).to respond_to(:items) }

  describe User, '#nameが設定済の場合' do
    specify 'validationに成功すること' do
      expect(subject).to be_valid
    end
  end

  describe User, '#name が空の場合' do
    before { @user.name = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe User, '#name の長さが20より長い場合' do
    before { @user.name = 'a' * 21 }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe User, '#name に含まれる文字が' do

    describe "'<','>'以外の文字の場合" do
      %w(A あ 0 - = / _ \\ ? % " ').each do |w|
        describe "例:'#{w}'" do
          before do
            @user.name = w
            @user.save
          end
          specify 'そのまま保存されること' do
            expect(@user.name).to eq(w)
          end
        end
      end
    end

    describe "'<'の場合" do
      before do
        @user.name = '<'
        @user.save
      end
      specify "'&lt;'に変換されること" do
        expect(@user.name).to eq('&lt;')
      end
    end

    describe "'>'の場合" do
      before do
        @user.name = '>'
        @user.save
      end
      specify "'&gt;'に変換されること" do
        expect(@user.name).to eq('&gt;')
      end

    end
  end
end
