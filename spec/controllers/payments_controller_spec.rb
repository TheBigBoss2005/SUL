require 'spec_helper'

describe PaymentsController do
  describe '清算完了' do
    context 'の正常に清算出来た場合' do
      before(:each) do
        @event = FG.create(:event)
        paymentor = FG.create(:user)
        item = FG.create(:item, user: paymentor, event: @event)
        part1 = FG.create(:participant, user: FG.create(:user), event: @event)
        part2 = FG.create(:participant, user: FG.create(:user), event: @event)
        part3 = FG.create(:participant, user: FG.create(:user), event: @event)
        @pay1 = FG.create(:payment, participant: part1, item: item)
        @pay2 = FG.create(:payment, participant: part2, item: item)
        @pay3 = FG.create(:payment, participant: part3, item: item)
      end

      it 'は清算終了したpaymentが削除される' do
        params = { id: @pay1.id, event_id: @event.id }

        delete :destroy, params

        expect(Payment.find_by(id: @pay1)).to be_nil
        expect(Payment.find(@pay2)).to be
        expect(Payment.find(@pay3)).to be
      end
    end
  end
end
