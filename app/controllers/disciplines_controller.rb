class DisciplinesController < ApplicationController

  def index
    @disciplines = Discipline.order(:name)
  end

  def show
    @discipline = Discipline.find(params[:id])
    redirect_to discipline_exam_dates_path(@discipline)
  end

end
