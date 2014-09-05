class PaymentsController < ApplicationController
  def index
    @users = User.all
    @events = Event.all
    payments = Payment.all

    if params[:filter_by_event] && params[:filter_by_event] != 'none'
      payments = payments.reject { |p| p.item.event.id != params[:filter_by_event].to_i }
    end

    if params[:filter_by_user] && params[:filter_by_user] != 'none'
      payments = payments.reject do |p|
        p.item.user.id != params[:filter_by_user].to_i &&
        p.participant.user.id != params[:filter_by_user].to_i
      end
    end

    @payments = Kaminari.paginate_array(payments).page params[:page] if payments
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
