class PeopleController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def create
    @person = Person.create(person_params)
    redirect_to new_checkin_path(person_id: @person.id, weight: checkin_params[:weight], location_id: @params[:location_id])
  end

  def index
    @people = Event.last.people
  end

  def show
    @person = Person.find(params[:id])
  end

  private
  def person_params
    params.required(:person).permit([:name])
  end

  def checkin_params
    params.required(:person).permit([:weight])
  end
end