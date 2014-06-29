class EventsController < ApplicationController
  def new
    @event = Event.new
    @users = User.all
  end

  def create
    @event = Event.new(event_params)
    @users = User.all
    if @event.save
      params[:event][:participant_ids].each do |p_id|
        @event.participants.create(user_id: p_id.to_i) unless p_id.empty?
      end
      flash[:success] = "イベント#{@event.name}を作成しました"
      # event一覧ページができたらそっちに遷移する
      # それまではイベント作成ページに戻る
      redirect_to '/newevent'
    else
      render 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    @users = User.all
  end

  def update
  end

  private

  def event_params
    params.require(:event).permit(:name, :memo, :date)
  end
end
