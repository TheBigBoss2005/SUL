require 'spec_helper'

describe PaymentsController do
  before(:each) do
    sign_in FG.create(:user)
    @event = FG.create(:event)
    paymentor = FG.create(:user)
    item = FG.create(:item, user: paymentor, event: @event)
    part1 = FG.create(:participant, user: FG.create(:user), event: @event)
    part2 = FG.create(:participant, user: FG.create(:user), event: @event)
    @pay1 = FG.create(:payment, participant: part1, item: item)
    @pay2 = FG.create(:payment, participant: part2, item: item)
  end

  describe '精算完了(単体)' do
    context 'で正常に清算出来た場合' do
      it 'は清算終了したpaymentがのステータスがtrueに変更される' do
        params = { id: @pay1.id, event_id: @event.id }

        delete :destroy, params

        expect(Payment.find(@pay1).status).to be_true
        expect(Payment.find(@pay2).status).to be_false
      end
    end
  end

  describe '精算完了(複数)' do
    context 'で正常に精算出来た場合' do
      it 'は清算終了したpaymentがのステータスがtrueに変更される' do
        params = { payment_ids: [@pay1.id, @pay2.id], event_id: @event.id }

        delete :bulk_destroy, params

        expect(Payment.find(@pay1).status).to be_true
        expect(Payment.find(@pay2).status).to be_true
        expect(flash[:success]).to be
      end
    end

    context 'で精算に失敗した場合' do
      it 'はidが指定されない場合にエラーになる' do
        params = { payment_ids: nil, event_id: @event.id }

        delete :bulk_destroy, params

        expect(Payment.find(@pay1).status).to be_false
        expect(Payment.find(@pay2).status).to be_false
        expect(flash[:error]).to be
      end
    end
  end
end
