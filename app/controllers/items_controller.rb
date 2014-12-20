class ItemsController < ApplicationController
  def new
    @item = Item.new
    @event = Event.find_by(id: params[:event_id].to_i)
  end

  def create
    @event = Event.find_by(id: params[:event_id].to_i)
    @item = create_item
    create_payment if @item.persisted?
    if @item.payments.empty?
      @item.delete
      render 'new'
    else
      redirect_to controller: 'events', action: 'show', id: @event.id
    end
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
    params[:payment][:source_user_ids].each do |source_user_id|
      payment_price = params[:payment_price][source_user_id]
      payment_price = 0 if payment_price.nil?
      status = @item.user_id == Participant.find_by(id: source_user_id).user_id ? true : false
      @item.payments.create(
        participant_id: source_user_id,
        price: payment_price,
        status: status
      )
    end
  end
end
