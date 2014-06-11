require 'spec_helper'

describe Event do
  before do
    @event = Event.new(
      name: '2014/05/31 SUL-meeting',
      memo: 'at my house',
      date: '2014/05/31')
  end

  subject { @event }

  it { should respond_to(:name) }
  it { should respond_to(:memo) }
  it { should respond_to(:date) }
  it { should respond_to(:participants) }
  it { should respond_to(:items) }

  it { should be_valid }

  describe 'when name is not present' do
    before { @event.name = ' ' }
    it { should_not be_valid }
  end

  describe 'when name is too long' do
    before { @event.name = 'a' * 41 }
    it { should_not be_valid }
  end

  describe 'when memo is not present' do
    before { @event.memo = ' ' }
    it { should be_valid }
  end

  describe 'when memo is too long' do
    before { @event.memo = 'a' * 41 }
    it { should_not be_valid }
  end

  %w(name memo).each do |column_name|
    describe "when #{column_name} includes" do

      describe 'word' do
        before { @event[column_name] = 'a' }
        it { should be_valid }
      end

      describe 'number' do
        before { @event[column_name] = '0' }
        it { should be_valid }
      end

      describe 'kana' do
        before { @event[column_name] = 'あ' }
        it { should be_valid }
      end

      describe 'half-kana' do
        before { @event[column_name] = 'ｱ' }
        it { should be_valid }
      end

      describe "'-'" do
        before { @event[column_name] = '-' }
        it { should be_valid }
      end

      describe "'\u30fc'" do
        before { @event[column_name] = 'ー' }
        it { should be_valid }
      end

      describe 'SPACE' do
        before { @event[column_name] = 'a b' }
        it { should be_valid }
      end

      describe 'SPACE(zenkaku)' do
        before { @event[column_name] = 'a　b' }
        it { should be_valid }
      end

      describe 'non-approved symbol' do
        before { @event[column_name] = '%' }
        it { should_not be_valid }
      end
    end

  end

  # date に関するテストはあとで考える
  # datetimeあたりが謎

end
