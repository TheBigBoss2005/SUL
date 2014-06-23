class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = "イベント#{@event.name}を作成しました"
      # event一覧ページができたらそっちに遷移する
      # それまではイベント作成ページに戻る
      redirect_to '/newevent'
    else
      render 'new'
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :memo, :date)
  end
end
