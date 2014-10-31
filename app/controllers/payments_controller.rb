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

    if params[:only_non_settleup] && params[:only_non_settleup] == 'yes'
      payments = payments.reject { |p| p.status == true }
    end

    @payments = Kaminari.paginate_array(payments).page params[:page] if payments
  end

  def confirm
    @payments = Payment.where(id: params[:payment_ids]).reject { |p| p.status == true }
  end

  def destroy
    payment = Payment.find(params[:id])
    payment.finished
    flash[:success] = '精算が完了しました！'
    redirect_to payments_path
  rescue
    flash[:error] = '不正な操作です。再度やり直して下さい'
    redirect_to payments_path
  end

  def bulk_destroy
    payments = Payment.where(id: params[:payment_ids])
    fail if payments.empty?
    payments.each { |payment| payment.finished }
    flash[:success] = '精算が完了しました！'
    redirect_to payments_path
  rescue
    flash[:error] = '不正な操作です。再度やり直して下さい'
    redirect_to payments_path
  end
end
