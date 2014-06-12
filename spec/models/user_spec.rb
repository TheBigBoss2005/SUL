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

    describe 'approved symbol' do
      %w(a あ ア ｱ 亜 0 ー / _ -).each do |w|
        describe "'#{w}'" do
          before { @user.name = w }
          it { should be_valid }
        end
      end
    end

    describe 'non-approved symbol' do
      %w(% \\ < > \' \").each do |w|
        describe "'#{w}'" do
          before { @user.name = w }
          it { should_not be_valid }
        end
      end
    end

    describe 'SPACE' do
      %w(\  　).each do |w|
        describe "'#{w}'" do
          before { @user.name = 'a' + w + 'b' }
          it { should be_valid }
        end
      end
    end

  end
end
