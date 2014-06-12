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

      describe 'approved symbol' do
        %w(a あ ア ｱ 亜 0 ー / _ -).each do |w|
          describe "'#{w}'" do
            before { @event[column_name] = w }
            it { should be_valid }
          end
        end
      end

      describe 'non-approved symbol' do
        %w(% \\ < > \' \").each do |w|
          describe "'#{w}'" do
            before { @event[column_name] = w }
            it { should_not be_valid }
          end
        end
      end

      describe 'SPACE' do
        %w(\  　).each do |w|
          describe "'#{w}'" do
            before { @event[column_name] = 'a' + w + 'b' }
            it { should be_valid }
          end
        end
      end

    end
  end

  # date に関するテストはあとで考える
  # datetimeあたりが謎

end
