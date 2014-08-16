class PaymentsController < ApplicationController
  def index
    @payments = Payment.page params[:page]
  end

  def destroy
    payment = Payment.find(params[:id])
    payment.finished
    flash[:success] = '清算が完了しました！'
    redirect_to payments_path
  rescue
    flash[:error] = '不正な操作です。再度やり直して下さい'
    redirect_to payments_path
  end
end
