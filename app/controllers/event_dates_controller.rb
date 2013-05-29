class EventDatesController < ApplicationController

  before_filter :authorize
  
  # def index
  #   @event_dates = EventDate.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @event_dates }
  #   end
  # end

  # def show
  #   @event_date = EventDate.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @event_date }
  #   end
  # end

  def new
    @event = Event.find params[:event_id]
    @event_date = @event.dates.build type: params[:type]

    if params[:type] == "exam"
      render :new_exam
    else
      raise "No Type specified!"
    end
  end

  def create
    @event = Event.find params[:event_id]
    params[:event_date]["end_time(3i)"] = params[:event_date]["start_time(3i)"]
    params[:event_date]["end_time(2i)"] = params[:event_date]["start_time(2i)"]
    params[:event_date]["end_time(1i)"] = params[:event_date]["start_time(1i)"]
    @event_date = @event.dates.build params[:event_date]

    if @event_date.save
      redirect_to dates_event_path(@event), notice: 'Termin erfolgreich gespeichert.'
    else
      render action: "new"
    end
  end

  # def update
  #   @event_date = EventDate.find(params[:id])

  #   respond_to do |format|
  #     if @event_date.update_attributes(params[:event_date])
  #       format.html { redirect_to @event_date, notice: 'Event date was successfully updated.' }
  #       format.json { head :ok }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @event_date.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def destroy
  #   @event_date = EventDate.find(params[:id])
  #   @event_date.destroy

  #   respond_to do |format|
  #     format.html { redirect_to event_dates_url }
  #     format.json { head :ok }
  #   end
  # end
end
