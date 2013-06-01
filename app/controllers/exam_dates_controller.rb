class ExamDatesController < ApplicationController

  before_filter :authorize, exept: [:index]

  def index
    @exam_dates = ExamDate.all

    @disciplines = @exam_dates.group_by(&:discipline)
  end

  def show
    @exam_date = ExamDate.find(params.fetch(:id))
  end

  def new
    @exam_date = ExamDate.new
  end

  def edit
    @exam_date = ExamDate.find(params[:id])
  end

  def create
    @exam_date = ExamDate.new(params[:exam_date])

    if @exam_date.save
      redirect_to @exam_date, notice: 'Exam date was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @exam_date = ExamDate.find(params[:id])

    if @exam_date.update_attributes(params[:exam_date])
      redirect_to @exam_date, notice: 'Exam date was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @exam_date = ExamDate.find(params[:id])
    @exam_date.destroy

    redirect_to exam_dates_url
  end
end
