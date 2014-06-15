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
  it { should respond_to(:formatted_date) }

  it { should be_valid }

  describe 'nameが空の場合' do
    before { @event.name = ' ' }
    it { should_not be_valid }
  end

  describe 'nameの長さが40より長い場合' do
    before { @event.name = 'a' * 41 }
    it { should_not be_valid }
  end

  describe 'memoが空の場合' do
    before { @event.memo = ' ' }
    it { should be_valid }
  end

  describe 'memoの長さが40より長い場合' do
    before { @event.memo = 'a' * 41 }
    it { should_not be_valid }
  end

  %w(name memo).each do |column_name|

    describe "#{column_name}に含まれる文字が" do

      describe "'<','>'以外の場合" do
        %w(A あ 0 - = / _ \\ " ').each do |w|
          describe "例:'#{w}'" do
            before do
              @event[column_name] = w
              @event.save
            end
            it 'そのまま保存されること' do
              expect(@event[column_name]).to eq(w)
            end
          end
        end
      end

      describe "'<'の場合" do
        before do
          @event[column_name] = '<'
          @event.save
        end
        it "'&lt;'に変換されること" do
          expect(@event[column_name]).to eq('&lt;')
        end
      end

      describe "'>'の場合" do
        before do
          @event[column_name] = '>'
          @event.save
        end
        it "'&gt;'に変換されること" do
          expect(@event[column_name]).to eq('&gt;')
        end
      end
    end
  end

  # Railsがうまいことやってくれる内容だけど、一応書いておく
  describe 'dateがdatetime形式に則っている場合' do
    before do
      @event.date = '2014/01/01'
      @event.save
    end
    it 'そのまま保存されること' do
      expect(@event.date).not_to eq(nil)
    end
  end

  # Railsがうまいことやってくれる内容だけど、一応書いておく
  describe 'dateがdatetime形式に則っていない場合' do
    before do
      @event.date = 'abc'
      @event.save
    end
    it 'nilに変換されること' do
      expect(@event.date).to eq(nil)
    end
  end

  describe '#formatted_date' do
    describe 'dateがnilでない場合' do
      before do
        @event.date = '2014/01/01'
        @event.save
      end
      it 'yyyy/mm/dd形式を返却すること' do
        expect(@event.formatted_date).to eq('2014/01/01')
      end
    end

    describe 'dateがnilの場合' do
      before do
        @event.date = nil
        @event.save
      end
      it '空文字列返却すること' do
        expect(@event.formatted_date).to eq(nil)
      end
    end
  end
end
