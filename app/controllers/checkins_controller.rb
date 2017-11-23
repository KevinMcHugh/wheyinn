class CheckinsController < ApplicationController
  before_action :authenticate_user!

  def create
    person = Person.find(checkin_params[:person_id])
    @checkin = CreateCheckin.call(person, Event.last, checkin_params[:weight].to_f, current_user)
    redirect_to people_path
  rescue
    flash[:error] = "Please fill out all fields"
    redirect_to new_checkin_path
  end

  def new
    @current_people = current_user.user_person_joins.order(:times_used).reverse.map(&:person)
    @current_locations = current_user.user_location_joins.map(&:location)
    @locations = (Location.all - @current_locations).sort_by { |p| p.name.downcase }
    @people = (Person.all - @current_people).sort_by { |p| p.name.downcase }
    @person = Person.find_by(id: params[:person_id])
    @location = Location.find_by(id: params[:location_id])
    @weight = params[:weight]
  end

  private
  def checkin_params
    params.require(:checkin).permit(:weight, :person_id)
  end
end