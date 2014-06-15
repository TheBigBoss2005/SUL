require 'spec_helper'

describe User do
  before do
    @user = User.new(name: 'Taro Yamada')
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:participants) }
  it { should respond_to(:items) }

  it { should be_valid }

  describe 'nameが空の場合' do
    before { @user.name = ' ' }
    it { should_not be_valid }
  end

  describe 'nameの長さが20より長い場合' do
    before { @user.name = 'a' * 21 }
    it { should_not be_valid }
  end

  describe 'nameに含まれる文字が' do

    describe "'<','>'以外の文字の場合" do
      %w(A あ 0 - = / _ \\ ? % " ').each do |w|
        describe "例:'#{w}'" do
          before do
            @user.name = w
            @user.save
          end
          it 'そのまま保存されること' do
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
      it "'&lt;'に変換されること" do
        expect(@user.name).to eq('&lt;')
      end
    end

    describe "'>'の場合" do
      before do
        @user.name = '>'
        @user.save
      end
      it "'&gt;'に変換されること" do
        expect(@user.name).to eq('&gt;')
      end

    end
  end
end
