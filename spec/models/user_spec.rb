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

  describe 'when name is not present' do
    before { @user.name = ' ' }
    it { should_not be_valid }
  end

  describe 'when name is too long' do
    before { @user.name = 'a' * 21 }
    it { should_not be_valid }
  end

  describe 'when name includes' do

    describe 'word' do
      before { @user.name = 'a' }
      it { should be_valid }
    end

    describe 'number' do
      before { @user.name = '0' }
      it { should be_valid }
    end

    describe 'kana' do
      before { @user.name = 'あ' }
      it { should be_valid }
    end

    describe 'half-kana' do
      before { @user.name = 'ｱ' }
      it { should be_valid }
    end

    describe "'-'" do
      before { @user.name = '-' }
      it { should be_valid }
    end

    describe "'\u30fc'" do
      before { @user.name = 'ー' }
      it { should be_valid }
    end

    describe 'SPACE' do
      before { @user.name = 'a b' }
      it { should be_valid }
    end

    describe 'SPACE(zenkaku)' do
      before { @user.name = 'a　b' }
      it { should be_valid }
    end

    describe 'non-approved symbol' do
      before { @user.name = '%' }
      it { should_not be_valid }
    end

  end
end
