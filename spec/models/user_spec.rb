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

    describe 'non-HTML-tag-symbol' do
      %w(A Ａ あ ア ｱ 亜 0 ０ - ー = ＝ / _ \\ ? % \" \').each do |w|
        describe "'#{w}'" do
          before do
            @user.name = w
            @user.save
          end
          specify { expect(@user.name).to eq(w) }
        end
      end
    end

    describe "HTML-tag-symbol '<'" do
      before do
        @user.name = '<'
        @user.save
      end
      specify { expect(@user.name).to eq('&lt;') }
    end

    describe "HTML-tag-symbol '>'" do
      before do
        @user.name = '>'
        @user.save
      end
      specify { expect(@user.name).to eq('&gt;') }
    end
  end
end
