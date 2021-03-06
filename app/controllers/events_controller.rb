class EventsController < ApplicationController
  def index
    @events = Event.page params[:page]
    @participants = Participant.all
  end

  def new
    @event = Event.new
    @users = User.all
  end

  def show
    @event = Event.find(params[:id])
    @items = @event.items.page(params[:page]).per(5)
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
      redirect_to @event
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
    if update_event
      add_participant
      redirect_to @event
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
end
