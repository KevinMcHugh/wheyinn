class CheckinsController < ApplicationController

  def create
    person = Person.find(checkin_params[:person_id])
    @checkin = CreateCheckin.call(person, Event.last, checkin_params[:weight].to_f)
    redirect_to people_path
  end

  def new
    @people = Person.all
  end

  private
  def checkin_params
    params.require(:checkin).permit(:weight, :person_id)
  end
end