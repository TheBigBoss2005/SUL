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
        @pay1 = FG.create(:payment, participant: part1, item: item)
        @pay2 = FG.create(:payment, participant: part2, item: item)
      end

      it 'は清算終了したpaymentがのステータスがtrueに変更される' do
        params = { id: @pay1.id, event_id: @event.id }

        delete :destroy, params

        expect(Payment.find(@pay1).status).to be_true
        expect(Payment.find(@pay2).status).to be_false
      end
    end
  end
end
