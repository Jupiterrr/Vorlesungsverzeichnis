class ExamDatesController < ApplicationController

  before_filter :authorize #, except: [:index, :show, :calendar]
  caches_action :index, :layout => false, cache_path: :index_cache_path.to_proc

  def index
    @discipline = Discipline.find(params[:discipline_id])
    @dates = @discipline.exam_dates.order(:date)
    @style = params[:style] == "calendar" ? "calendar" : "list"
    if @style != "list"
      @exam_date_calendar = ExamDateCalendar.new(@dates)
    end
  end

  def show
    @exam_date = ExamDate.find(params.fetch(:id))
  end

  def new
    @exam_date = discipline.exam_dates.new
  end

  def edit
    @exam_date = ExamDate.find(params[:id])
  end

  def create
    @exam_date = discipline.exam_dates.new(params[:exam_date])

    if @exam_date.save
      expire_action :action => :index
      redirect_to discipline_exam_date_path(discipline, @exam_date), notice: 'Exam date was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @exam_date = ExamDate.find(params[:id])

    if @exam_date.update_attributes(params[:exam_date])
      expire_action :action => :index
      redirect_to discipline_exam_date_path(discipline, @exam_date), notice: 'Exam date was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @exam_date = ExamDate.find(params[:id])
    @exam_date.destroy
    redirect_to discipline_exam_dates_path(discipline)
  end

  private

  def discipline
    @discipline ||= Discipline.find(params[:discipline_id])
  end
  helper_method :discipline

  protected
  def index_cache_path
    style = params[:style] == "calendar" ? "calendar" : "list"
    "#{request.path}##{style}"
  end

end
