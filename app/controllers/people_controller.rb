class PeopleController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def create
    @person = Person.create(person_params)
    CreateCheckin.call(@person, Event.last, checkin_params[:weight].to_f, current_user)
    redirect_to people_path
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