require 'spec_helper'

describe Event do
  before do
    @event = Event.new(
      name: '2014/05/31 SUL-meeting',
      memo: 'at my house',
      date: '2014/05/31')
  end

  subject { @event }

  specify { expect(subject).to respond_to(:name) }
  specify { expect(subject).to respond_to(:memo) }
  specify { expect(subject).to respond_to(:date) }
  specify { expect(subject).to respond_to(:participants) }
  specify { expect(subject).to respond_to(:users) }
  specify { expect(subject).to respond_to(:items) }
  specify { expect(subject).to respond_to(:formatted_date) }

  describe Event, '#name, #memo, #dateが設定済の場合' do
    specify 'validationに成功すること' do
      expect(subject).to be_valid
    end
  end

  describe Event, '#nameが空の場合' do
    before { @event.name = ' ' }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Event, '#nameの長さが40より長い場合' do
    before { @event.name = 'a' * 41 }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  describe Event, '#memoが空の場合' do
    before { @event.memo = ' ' }
    specify 'validationに成功すること' do
      expect(subject).to be_valid
    end
  end

  describe Event, '#memoの長さが40より長い場合' do
    before { @event.memo = 'a' * 41 }
    specify 'validationに失敗すること' do
      expect(subject).not_to be_valid
    end
  end

  %w(name memo).each do |column_name|

    describe Event, "##{column_name}に含まれる文字が" do

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
  describe Event, '#dateがdatetime形式に則っている場合' do
    before do
      @event.date = '2014/01/01'
      @event.save
    end
    it 'そのまま保存されること' do
      expect(@event.date).not_to eq(nil)
    end
  end

  # Railsがうまいことやってくれる内容だけど、一応書いておく
  describe Event, '#dateがdatetime形式に則っていない場合' do
    before do
      @event.date = 'abc'
      @event.save
    end
    it 'nilに変換されること' do
      expect(@event.date).to eq(nil)
    end
  end

  describe Event, '#formatted_date' do
    describe Event, '#dateがnilでない場合' do
      before do
        @event.date = '2014/01/01'
        @event.save
      end
      it 'yyyy/mm/dd形式を返却すること' do
        expect(@event.formatted_date).to eq('2014/01/01')
      end
    end

    describe Event, '#dateがnilの場合' do
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
