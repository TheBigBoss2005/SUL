class PaymentsController < ApplicationController
  def index
  end

  def destroy
    payment = Payment.find(params[:id])
    payment.destroy
    flash[:success] = '清算が完了しました！'
    redirect_to event_payments_path
  rescue
    flash[:error] = '不正な操作です。再度やり直して下さい'
    redirect_to event_payments_path
  end
end
