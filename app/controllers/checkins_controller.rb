class CheckinsController < ApplicationController

  def create
    @checkin = Checkin.create(checkin_params.merge(event: Event.last))
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