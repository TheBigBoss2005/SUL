class EventsController < ApplicationController
  def index
  @event=Event.all
  @participants=Participant.all
end

  def new
    @event = Event.new
    @users = User.all
  end

  def create
    @event = Event.new(event_params)
    @users = User.all
    if @event.save
      if params[:event][:participant_ids]
        params[:event][:participant_ids].each do |p_id|
          @event.participants.create(user_id: p_id.to_i) unless p_id.empty?
        end
      end
      flash[:success] = "イベント#{@event.name}を作成しました"
      # event一覧ページができたらそっちに遷移する
      # それまではイベント作成ページに戻る
      redirect_to action: 'new'
    else
      render 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    @users = User.all
    @not_participate_users = @users - @event.users
  end

  def update
    @event = Event.find(params[:id])
    @users = User.all
    @not_participate_users = @users - @event.users
    # update event
    if update_event
      # add participant
      add_participant
      # create item and payment
      create_payment if @item = create_item
      @item.delete if @item.payments.empty?
      redirect_to action: 'edit'
    else
      render 'edit'
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :memo, :date)
  end

  def update_event
    @event.name = params[:event][:name]
    @event.memo = params[:event][:memo]
    @event.date = params[:event][:date]
    @event.save
  end

  def add_participant
    params[:event][:participant_ids].each do |p_id|
      @event.participants.create(user_id: p_id.to_i) unless p_id.empty?
    end if params[:event][:participant_ids]
  end

  def create_item
    @event.items.create(
      memo: params[:item][:memo],
      price: params[:item][:price],
      user_id: params[:payment][:dest_user_id]
    )
  end

  def create_payment
    return unless params[:payment][:source_user_ids]
    price_par_payment = @item.price / params[:payment][:source_user_ids].count
    params[:payment][:source_user_ids].each do |source_user_id|
      status = @item.user_id == Participant.find_by(id: source_user_id).user_id ? true : false
      @item.payments.create(
        participant_id: source_user_id,
        price: price_par_payment,
        status: status
      )
    end
  end
end
